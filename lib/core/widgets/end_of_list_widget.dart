import '../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EndOfListWidget extends StatelessWidget {
  const EndOfListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Column(
          children: const [
            Icon(Icons.check_circle_outline, size: 24, color: AppColors.colorTextMuted),
            SizedBox(height: 8),
            Text(
              "You've seen it all!",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.colorTextMuted),
            ),
          ],
        ),
      ),
    );
  }
}
