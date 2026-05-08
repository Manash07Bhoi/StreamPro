import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BrightnessHud extends StatelessWidget {
  final double brightness;

  const BrightnessHud({super.key, required this.brightness});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      top: MediaQuery.of(context).size.height / 2 - 80,
      child: Container(
        width: 40,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.brightness_6, color: Colors.white, size: 20),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: LinearProgressIndicator(
                      value: brightness,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.colorPrimary),
                      minHeight: 8,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '${(brightness * 100).toInt()}%',
                style: const TextStyle(
                    color: Colors.white, fontSize: 10, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
