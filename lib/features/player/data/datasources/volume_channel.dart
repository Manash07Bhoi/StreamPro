import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class VolumeChannel {
  static const _channel = MethodChannel('com.streampro.app/volume');

  Future<double> getCurrentVolume() async {
    try {
      return await _channel.invokeMethod<double>('getVolume') ?? 1.0;
    } on PlatformException {
      return 1.0;
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _channel.invokeMethod('setVolume', {'volume': volume.clamp(0.0, 1.0)});
    } on PlatformException catch (e) {
      debugPrint('Volume error: ${e.message}');
    }
  }
}
