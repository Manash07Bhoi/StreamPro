import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player_bloc.dart';
import '../blocs/pip_bloc.dart';

class PlayerGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onRevealComments;

  const PlayerGestureDetector({
    super.key,
    required this.child,
    required this.onRevealComments,
  });

  @override
  State<PlayerGestureDetector> createState() => _PlayerGestureDetectorState();
}

class _PlayerGestureDetectorState extends State<PlayerGestureDetector> {
  double _startDragY = 0;
  double _startDragX = 0;
  bool _isHorizontalDrag = false;
  double _initialBrightness = 0.5;
  double _initialVolume = 1.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is! PlayerReady) return widget.child;

        return Stack(
          children: [
            widget.child,
            // The transparent gesture overlay
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  context.read<PlayerBloc>().add(ToggleControlsVisibility());
                },
                onDoubleTapDown: (details) {
                  final width = MediaQuery.of(context).size.width;
                  if (details.localPosition.dx < width * 0.4) {
                    context.read<PlayerBloc>().add(SeekDelta(-10));
                  } else if (details.localPosition.dx > width * 0.6) {
                    context.read<PlayerBloc>().add(SeekDelta(10));
                  }
                },
                onScaleUpdate: (details) {
                  if (details.scale > 1.2 && !state.isFillMode) {
                    context.read<PlayerBloc>().add(ToggleFitMode());
                  } else if (details.scale < 0.8 && state.isFillMode) {
                    context.read<PlayerBloc>().add(ToggleFitMode());
                  }
                },
                onLongPressStart: (details) {
                  final width = MediaQuery.of(context).size.width;
                  if (details.localPosition.dx > width * 0.4 && details.localPosition.dx < width * 0.6) {
                    context.read<PlayerBloc>().add(SetSpeed(2.0));
                  }
                },
                onLongPressEnd: (details) {
                  context.read<PlayerBloc>().add(SetSpeed(1.0));
                },
                onVerticalDragStart: (details) {
                  _startDragY = details.localPosition.dy;
                  _startDragX = details.localPosition.dx;
                  _initialBrightness = state.brightness;
                  _initialVolume = state.volume;
                },
                onVerticalDragUpdate: (details) {
                  final dy = details.localPosition.dy;
                  final dx = details.localPosition.dx;
                  final width = MediaQuery.of(context).size.width;
                  final height = MediaQuery.of(context).size.height;

                  final deltaY = _startDragY - dy; // up is positive
                  final adjustment = (deltaY / height) * 2; // scale factor

                  if (dx < width * 0.4) {
                    // Brightness
                    context.read<PlayerBloc>().add(SetBrightness(_initialBrightness + adjustment));
                  } else if (dx > width * 0.6) {
                    // Volume
                    context.read<PlayerBloc>().add(SetVolume(_initialVolume + adjustment));
                  }
                },
                onVerticalDragEnd: (details) {
                  final width = MediaQuery.of(context).size.width;
                  final height = MediaQuery.of(context).size.height;

                  // Top Edge Swipe Down -> PiP
                  if (_startDragY < height * 0.15 && details.primaryVelocity != null && details.primaryVelocity! > 400) {
                     context.read<PipBloc>().add(ActivatePip(state.video, state.currentSeconds));
                     Navigator.of(context).pop(); // Mocking minimize
                  }

                  // Bottom Edge Swipe Up -> Reveal Comments
                  if (_startDragY > height * 0.8 && details.primaryVelocity != null && details.primaryVelocity! < -300) {
                     widget.onRevealComments();
                  }
                },
                onHorizontalDragStart: (details) {
                  _startDragX = details.localPosition.dx;
                  _startDragY = details.localPosition.dy;
                  _isHorizontalDrag = true;
                },
                onHorizontalDragUpdate: (details) {
                  // Stub for seeking scrub visual
                },
                onHorizontalDragEnd: (details) {
                  _isHorizontalDrag = false;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
