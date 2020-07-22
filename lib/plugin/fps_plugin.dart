/// do what
/// @author yulun
/// @since 2020-07-21 18:11

import 'dart:async';

import 'package:flutter/services.dart';

class FpsPlugin {
  static const MethodChannel _channel =
  const MethodChannel('fps');

  static Future<double> get getRefreshRate async {
    final double fpsHz = await _channel.invokeMethod('getRefreshRate') ?? 60;
    return fpsHz;
  }
}
