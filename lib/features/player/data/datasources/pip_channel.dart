import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class PipChannel {
  static const _channel = MethodChannel('com.streampro.app/pip');
  static const _eventChannel = EventChannel('com.streampro.app/pip_events');

  Future<bool> isPipSupported() async {
    try {
      return await _channel.invokeMethod<bool>('isSupported') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> enterPip({required int width, required int height}) async {
    try {
      await _channel.invokeMethod('enterPip', {'width': width, 'height': height});
    } on PlatformException catch (e) {
      debugPrint('PiP error: ${e.message}');
    }
  }

  Future<void> exitPip() async {
    try {
      await _channel.invokeMethod('exitPip');
    } on PlatformException catch (e) {
      debugPrint('Exit PiP error: ${e.message}');
    }
  }

  Stream<String> get pipEventStream => _eventChannel
      .receiveBroadcastStream()
      .map((event) => event.toString());
}
