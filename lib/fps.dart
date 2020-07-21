import 'dart:async';

import 'package:flutter/services.dart';

class Fps {
  static const MethodChannel _channel =
      const MethodChannel('fps');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
