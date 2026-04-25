import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/di/injection.dart';
import '../../../discover/data/repositories/video_repository.dart';
import 'package:go_router/go_router.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoEntity video;

  const VideoPlayerPage({super.key, required this.video});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  InAppWebViewController? _webViewController;
  bool _isPlaying = true;
  bool _controlsVisible = true;
  bool _isBookmarked = false;
  double _brightness = 0.5;
  double _volume = 0.5;
  bool _isFillMode = false;
  bool _showBrightnessHud = false;
  bool _showVolumeHud = false;

  @override
  void initState() {
    super.initState();
    _enterImmersiveMode();
    _checkBookmarkStatus();
    // Simulate setting initial system brightness/volume internally
  }

  void _enterImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _exitImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _checkBookmarkStatus() async {
    final repo = getIt<VideoRepository>();
    final status = repo.isBookmarked(widget.video.id);
    if (mounted) {
      setState(() {
        _isBookmarked = status;
      });
    }
  }

  @override
  void dispose() {
    _exitImmersiveMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Player
          Transform.scale(
             scale: _isFillMode ? 1.3 : 1.0,
             child: AbsorbPointer(
               absorbing: true, // Absorb pointer to let GestureDetector handle all touches
               child: InAppWebView(
                 initialData: InAppWebViewInitialData(
                   data: _buildHtmlContent(widget.video.embedCode),
                 ),
                 initialSettings: InAppWebViewSettings(
                   mediaPlaybackRequiresUserGesture: false,
                   allowsInlineMediaPlayback: true,
                   iframeAllowFullscreen: true,
                 ),
                 onWebViewCreated: (controller) {
                   _webViewController = controller;
                 },
               ),
             ),
          ),

          // Gesture Overlay
          GestureDetector(
             onTap: () {
               setState(() {
                 _controlsVisible = !_controlsVisible;
               });
             },
             onDoubleTapDown: (details) {
                final width = MediaQuery.of(context).size.width;
                if (details.globalPosition.dx < width * 0.4) {
                   Haptics.vibrate(HapticsType.light);
                   // Seek Backward
                } else if (details.globalPosition.dx > width * 0.6) {
                   Haptics.vibrate(HapticsType.light);
                   // Seek Forward
                }
             },
             onVerticalDragUpdate: (details) {
                final width = MediaQuery.of(context).size.width;
                if (details.globalPosition.dx < width * 0.4) {
                   // Brightness
                   setState(() {
                     _showBrightnessHud = true;
                     _brightness -= details.delta.dy * 0.002;
                     _brightness = _brightness.clamp(0.05, 1.0);
                   });
                } else if (details.globalPosition.dx > width * 0.6) {
                   // Volume
                   setState(() {
                     _showVolumeHud = true;
                     _volume -= details.delta.dy * 0.002;
                     _volume = _volume.clamp(0.0, 1.0);
                   });
                }
             },
             onVerticalDragEnd: (details) {
                setState(() {
                  _showBrightnessHud = false;
                  _showVolumeHud = false;
                });

                // PiP / Minimize (swipe down from top edge)
                if (details.primaryVelocity != null && details.primaryVelocity! > 400) {
                   Haptics.vibrate(HapticsType.medium);
                   context.pop();
                }

                // Comments sheet (swipe up from bottom edge)
                if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
                   Haptics.vibrate(HapticsType.light);
                   _showCommentsSheet();
                }
             },
             onScaleUpdate: (details) {
                if (details.scale > 1.2 && !_isFillMode) {
                   Haptics.vibrate(HapticsType.medium);
                   setState(() { _isFillMode = true; });
                } else if (details.scale < 0.8 && _isFillMode) {
                   Haptics.vibrate(HapticsType.medium);
                   setState(() { _isFillMode = false; });
                }
             },
             onLongPressStart: (_) {
                Haptics.vibrate(HapticsType.heavy);
                // 2x speed
             },
             onLongPressEnd: (_) {
                Haptics.vibrate(HapticsType.light);
                // 1x speed
             },
             child: Container(color: Colors.transparent),
          ),

          // HUD Overlays
          if (_showBrightnessHud)
             Positioned(
                left: 32, top: 0, bottom: 0,
                child: Center(
                   child: Container(
                      width: 48, height: 160,
                      decoration: BoxDecoration(
                         color: Colors.black45,
                         borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                            Expanded(child: RotatedBox(quarterTurns: -1, child: LinearProgressIndicator(value: _brightness, backgroundColor: Colors.transparent, color: Theme.of(context).primaryColor))),
                            const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.brightness_6, color: Colors.white, size: 24)),
                         ]
                      )
                   )
                )
             ),

          if (_showVolumeHud)
             Positioned(
                right: 32, top: 0, bottom: 0,
                child: Center(
                   child: Container(
                      width: 48, height: 160,
                      decoration: BoxDecoration(
                         color: Colors.black45,
                         borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                            Expanded(child: RotatedBox(quarterTurns: -1, child: LinearProgressIndicator(value: _volume, backgroundColor: Colors.transparent, color: Theme.of(context).primaryColor))),
                            Padding(padding: const EdgeInsets.all(8.0), child: Icon(_volume == 0 ? Icons.volume_off : Icons.volume_up, color: Colors.white, size: 24)),
                         ]
                      )
                   )
                )
             ),

          // Controls Overlay
          if (_controlsVisible)
            Container(
              color: Colors.black45,
              child: Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: Text(
                            widget.video.title,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cast, color: Colors.white),
                          onPressed: () => context.push('/cast'),
                        ),
                        IconButton(
                          icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
                          onPressed: () async {
                            Haptics.vibrate(HapticsType.selection);
                            await getIt<VideoRepository>().toggleBookmark(widget.video.id);
                            _checkBookmarkStatus();
                          },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Center Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 48),
                        onPressed: () { Haptics.vibrate(HapticsType.selection); },
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white, size: 64),
                        onPressed: () {
                          Haptics.vibrate(HapticsType.selection);
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 48),
                        onPressed: () { Haptics.vibrate(HapticsType.selection); },
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Bottom Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Row(
                      children: [
                        const Text('00:00', style: TextStyle(color: Colors.white)),
                        Expanded(
                          child: Slider(
                            value: 0.0,
                            onChanged: (val) {},
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(widget.video.duration, style: const TextStyle(color: Colors.white)),
                        IconButton(
                           icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
                           onPressed: () {},
                        )
                      ],
                    ),
                  ),

                  // Comments Hint
                  Padding(
                     padding: const EdgeInsets.only(bottom: 8.0),
                     child: GestureDetector(
                        onTap: _showCommentsSheet,
                        child: const Text('↑ More', style: TextStyle(color: Colors.white70, fontSize: 12)),
                     )
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showCommentsSheet() {
     showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
           return DraggableScrollableSheet(
              initialChildSize: 0.45,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              builder: (_, controller) {
                 return Container(
                    decoration: BoxDecoration(
                       color: Theme.of(context).colorScheme.surface,
                       borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
                    ),
                    child: Column(
                       children: [
                          const SizedBox(height: 8),
                          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 16),
                          Text('Comments & Related', style: Theme.of(context).textTheme.titleLarge),
                          Expanded(
                             child: Center(child: Text('Comments Placeholder', style: TextStyle(color: Colors.grey.shade400))),
                          )
                       ]
                    )
                 );
              }
           );
        }
     );
  }

  String _buildHtmlContent(String embedCode) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
          body { margin: 0; padding: 0; background-color: black; overflow: hidden; }
          .video-container { position: relative; width: 100vw; height: 100vh; display: flex; justify-content: center; align-items: center; }
          iframe { width: 100%; height: 100%; border: none; }
        </style>
      </head>
      <body>
        <div class="video-container">
          $embedCode
        </div>
      </body>
      </html>
    ''';
  }
}
