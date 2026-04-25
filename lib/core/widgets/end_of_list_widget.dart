import 'package:flutter/material.dart';

class EndOfListWidget extends StatelessWidget {
  const EndOfListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            "You've seen it all!",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
