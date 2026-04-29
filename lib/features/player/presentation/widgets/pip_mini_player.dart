import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/pip_bloc.dart';

class PipMiniPlayer extends StatefulWidget {
  const PipMiniPlayer({super.key});

  @override
  State<PipMiniPlayer> createState() => _PipMiniPlayerState();
}

class _PipMiniPlayerState extends State<PipMiniPlayer> {
  Offset _position = const Offset(20, 100);
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PipBloc, PipState>(
      builder: (context, state) {
        if (state is! PipActive || !state.isMinimized) return const SizedBox.shrink();

        return Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _position += details.delta;
              });
            },
            onPanEnd: (details) {
              // Snap to edge
              final screenWidth = MediaQuery.of(context).size.width;
              if (_position.dx < screenWidth / 2) {
                setState(() => _position = Offset(16, _position.dy));
              } else {
                setState(() => _position = Offset(screenWidth - 196, _position.dy)); // 180 width + 16 margin
              }
            },
            onTap: () {
              context.read<PipBloc>().add(ReturnToFullscreen());
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 180,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha:0.5), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                  border: Border.all(color: const Color(0xFF242424)),
                ),
                child: Stack(
                  children: [
                    Center(child: Text(state.video.title, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => context.read<PipBloc>().add(DeactivatePip()),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _isPlaying = !_isPlaying);
                        },
                        child: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white70, size: 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
