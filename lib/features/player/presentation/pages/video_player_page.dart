import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../discover/data/repositories/video_repository.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoEntity video;

  const VideoPlayerPage({super.key, required this.video});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with SingleTickerProviderStateMixin {
  InAppWebViewController? webViewController;
  bool _showControls = true;
  bool _isBookmarked = false;
  final _repository = getIt<VideoRepository>();
  List<VideoEntity> _relatedVideos = [];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.value = 1.0; // Show initially

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
    await _repository.addToHistory(widget.video);
    final bookmarked = await _repository.isBookmarked(widget.video.id);
    final allVideos = await _repository.getAllVideos();

    // Filter related videos (e.g. same category)
    final related = allVideos
        .where((v) =>
            v.id != widget.video.id && v.category == widget.video.category)
        .toList();
    if (related.isEmpty) {
      related.addAll(allVideos.where((v) => v.id != widget.video.id).take(5));
    }

    if (mounted) {
      setState(() {
        _isBookmarked = bookmarked;
        _relatedVideos = related;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    webViewController?.dispose();
    // Restore system UI and portrait orientation on exit
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  bool _isPopping = false;

  void _safePop() {
    if (_isPopping) return;
    _isPopping = true;
    HapticFeedback.selectionClick();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
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
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _safePop();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                  if (_showControls) {
                    _fadeController.forward();
                  } else {
                    _fadeController.reverse();
                  }
                });
              },
              child: Stack(
                children: [
                  // WebView Player
                  InAppWebView(
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

                  // Controls Overlay
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.0, 0.2, 0.8, 1.0],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top Bar
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios_new,
                                        color: Colors.white),
                                    onPressed: _safePop,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.video.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: _isBookmarked
                                          ? const Color(0xFFC026D3)
                                          : Colors.white,
                                    ),
                                    onPressed: () async {
                                      await _repository
                                          .toggleBookmark(widget.video);
                                      setState(() {
                                        _isBookmarked = !_isBookmarked;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom Overlay with Fake Controls and Related Videos
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fake Controls
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('00:00',
                                        style: TextStyle(color: Colors.white)),
                                    Expanded(
                                      child: Slider(
                                        value: 0.0,
                                        onChanged: (value) {},
                                        activeColor: const Color(0xFFC026D3),
                                        inactiveColor: Colors.grey,
                                      ),
                                    ),
                                    Text(widget.video.duration,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.fullscreen,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                              // Related Videos
                              if (_relatedVideos.isNotEmpty) ...[
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    'Related Videos',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 140,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _relatedVideos.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            AppRoutes.player,
                                            arguments: _relatedVideos[index],
                                          );
                                        },
                                        child: AbsorbPointer(
                                          // Absorb so the card's native tap doesn't push a new route on top of this one
                                          child: PremiumVideoCard(
                                            video: _relatedVideos[index],
                                            width: 220,
                                            height: 140,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
