import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class BrightnessChannel {
  static const _channel = MethodChannel('com.streampro.app/brightness');

  Future<double> getCurrentBrightness() async {
    try {
      final double brightness = await _channel.invokeMethod('getBrightness');
      return brightness;
    } on PlatformException {
      return 0.5; // fallback
    }
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await _channel.invokeMethod('setBrightness', {'brightness': brightness.clamp(0.05, 1.0)});
    } on PlatformException catch (e) {
      debugPrint('Brightness error: ${e.message}');
    }
  }

  Future<void> restoreSystemBrightness() async {
    try {
      await _channel.invokeMethod('restoreSystemBrightness');
    } on PlatformException catch (e) {
      debugPrint('Restore brightness error: ${e.message}');
    }
  }
}
