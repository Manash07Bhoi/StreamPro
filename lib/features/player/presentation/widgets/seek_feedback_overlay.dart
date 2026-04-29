import 'package:flutter/material.dart';

class SeekFeedbackOverlay extends StatefulWidget {
  final bool isForward;
  final VoidCallback onComplete;

  const SeekFeedbackOverlay({
    super.key,
    required this.isForward,
    required this.onComplete,
  });

  @override
  State<SeekFeedbackOverlay> createState() => _SeekFeedbackOverlayState();
}

class _SeekFeedbackOverlayState extends State<SeekFeedbackOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = _controller.value < 0.5
            ? _controller.value * 2
            : (1.0 - _controller.value) * 2;

        return Positioned(
          left: widget.isForward ? null : 40,
          right: widget.isForward ? 40 : null,
          top: MediaQuery.of(context).size.height / 2 - 40,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha:0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isForward) const Icon(Icons.fast_rewind, color: Colors.white),
                  if (!widget.isForward) const SizedBox(width: 8),
                  const Text('10s', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                  if (widget.isForward) const SizedBox(width: 8),
                  if (widget.isForward) const Icon(Icons.fast_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
