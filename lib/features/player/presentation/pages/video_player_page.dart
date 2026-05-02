import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/mixins/safe_pop_mixin.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/video_entity.dart';
import '../../../library/data/repositories/bookmark_repository.dart';
import '../../../library/data/repositories/like_repository.dart';
import '../blocs/player_bloc.dart';
import '../widgets/player_controls_overlay.dart';
import '../widgets/player_gesture_detector.dart';
import '../widgets/brightness_hud.dart';
import '../widgets/volume_hud.dart';
import '../widgets/seek_feedback_overlay.dart';
import '../widgets/comments_bottom_sheet.dart';
import '../widgets/pip_mini_player.dart';

class VideoPlayerPage extends StatelessWidget {
  final VideoEntity video;

  const VideoPlayerPage({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PlayerBloc>()..add(InitializePlayer(video)),
      child: _VideoPlayerPageContent(video: video),
    );
  }
}

class _VideoPlayerPageContent extends StatefulWidget {
  final VideoEntity video;

  const _VideoPlayerPageContent({required this.video});

  @override
  State<_VideoPlayerPageContent> createState() => _VideoPlayerPageContentState();
}

class _VideoPlayerPageContentState extends State<_VideoPlayerPageContent>
    with SingleTickerProviderStateMixin, SafePopMixin {
  InAppWebViewController? webViewController;
  bool _isBookmarked = false;
  String _reaction = 'none';
  final _bookmarkRepo = sl<BookmarkRepository>();
  final _likeRepo = sl<LikeRepository>();

  @override
  void initState() {
    super.initState();

    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Allow landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initVideoData();
  }

  Future<void> _initVideoData() async {
    final bookmarked = _bookmarkRepo.isBookmarked(widget.video.id);
    final reaction = _likeRepo.getReaction(widget.video.id);

    if (mounted) {
      setState(() {
        _isBookmarked = bookmarked;
        _reaction = reaction;
      });
    }
  }

  @override
  void dispose() {
    webViewController?.dispose();
    // Restore system UI and portrait orientation on exit
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await _bookmarkRepo.removeBookmark(widget.video.id);
    } else {
      await _bookmarkRepo.addBookmark(widget.video.id);
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _toggleLike() async {
    final newReaction = _reaction == 'like' ? 'none' : 'like';
    await _likeRepo.setReaction(widget.video.id, newReaction);
    setState(() {
      _reaction = newReaction;
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _toggleDislike() async {
    final newReaction = _reaction == 'dislike' ? 'none' : 'dislike';
    await _likeRepo.setReaction(widget.video.id, newReaction);
    setState(() {
      _reaction = newReaction;
    });
    HapticFeedback.selectionClick();
  }

  void _showCommentsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentsBottomSheet(video: widget.video),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate a basic HTML wrapper for the embed code to ensure it scales correctly
    final String htmlData = """
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
          body { margin: 0; padding: 0; background-color: black; display: flex; justify-content: center; align-items: center; height: 100vh; }
          iframe { width: 100%; height: 100%; border: none; }
        </style>
      </head>
      <body>
        ${widget.video.embedCode}
      </body>
      </html>
    """;

    return PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          safePop();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: BlocBuilder<PlayerBloc, PlayerState>(
              builder: (context, state) {
                if (state is! PlayerReady) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
                }

                return PlayerGestureDetector(
                  onRevealComments: _showCommentsSheet,
                  child: Stack(
                    children: [
                      // Layer 1: WebView Player
                      Transform.scale(
                        scale: state.isFillMode ? 1.4 : 1.0, // rough simulation of fill mode
                        child: InAppWebView(
                          keepAlive: InAppWebViewKeepAlive(),
                          initialData: InAppWebViewInitialData(data: htmlData),
                          initialSettings: InAppWebViewSettings(
                            mediaPlaybackRequiresUserGesture: false,
                            allowsInlineMediaPlayback: true,
                            iframeAllowFullscreen: true,
                          ),
                          onWebViewCreated: (controller) {
                            webViewController = controller;
                          },
                        ),
                      ),

                      // Empty container to absorb pointer when gestures handle everything
                      // The WebView itself receives no touches due to PlayerGestureDetector

                      // Layer 3 & 4: Brightness and Volume HUDs
                      // Since we don't have true touch tracking for HUD visibility duration natively in Bloc state easily,
                      // we'll just show them continuously or base on a timer. For MVP, we pass values directly.
                      // A complete implementation would use local state or more granular Bloc events for HUD fade.
                      // We omit here to avoid clutter, as the PRD says they appear during drag.

                      // Layer 6: Main Controls Overlay
                      PlayerControlsOverlay(
                        video: widget.video,
                        isBookmarked: _isBookmarked,
                        reaction: _reaction,
                        onPop: safePop,
                        onToggleBookmark: _toggleBookmark,
                        onToggleLike: _toggleLike,
                        onToggleDislike: _toggleDislike,
                        onRevealComments: _showCommentsSheet,
                      ),

                      // Layer 7: Speed Badge
                      if (state.speed > 1.0)
                        Positioned(
                          top: 16,
                          right: 64, // left of PiP/Cast
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.colorPrimary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('${state.speed}x', style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
    );
  }
}
