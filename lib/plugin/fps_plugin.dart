/// do what
/// @author yulun
/// @since 2020-07-21 18:11

import 'dart:async';

import 'package:flutter/services.dart';

class FpsPlugin {
  static const MethodChannel _channel =
  const MethodChannel('fps');

  /// 默认为60帧，以手机的实际刷新帧率为准
  static Future<double> get getRefreshRate async {
    final double fpsHz = await _channel.invokeMethod('getRefreshRate') ?? 60;
    return fpsHz;
  }
}
