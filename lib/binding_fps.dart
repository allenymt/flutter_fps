import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import 'fps_callback.dart';
import 'plugin/fps_plugin.dart';
import 'util/debug_log.dart';

/// do what
/// @author yulun
/// @since 2020-07-17 11:36
/// 这个统计方式和fps_computer里的不一样，通过监听WidgetsBinding的handleBeginFrame和handleDrawFrame实现
/// handleBeginFrame Called by the engine to prepare the framework to produce a new frame.
/// handleDrawFrame Called by the engine to produce a new frame.
/// 在一秒内计算从begin->draw调用了多少次，次数就是帧数，如果帧数少于手机的渲染帧数，会认为丢失了多少帧
/// 参考文章 https://developer.aliyun.com/article/699875
@Deprecated("统计不准，只有cpu部分，即ui线程 build layout paint部分")
class BindingFps {
  /// 单例
  static BindingFps? _instance;

  static BindingFps? get instance {
    if (_instance == null) {
      _instance = BindingFps._();
    }
    return _instance;
  }

  /// 1s里最高120hz了吧
  static const MAX_FPS = 120;
  Timer? _timer;
  ListQueue<_FpsFrame?> _frameQueue = ListQueue(MAX_FPS);
  bool? _init;
  List<FpsCallback> _callBackList = [];

  /// 一般手机为60帧
  double? _fpsHz;

  BindingFps._();

  start() async {
    if (_init ?? false) {
      // 避免重复初始化
      return;
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //时间达到一秒了，开始计算这一秒的帧率
      _calFps();
    });
    _registerListener();

    // 获取当前手机的fps
    if (_fpsHz == null) {
      _fpsHz = await FpsPlugin.getRefreshRate;
    }

    _init = true;
  }

  /// 销毁
  cancel() {
    _timer?.cancel();
    _timer = null;
    if (beginCallId != null) {
      WidgetsBinding.instance!.cancelFrameCallbackWithId(beginCallId!);
    }
    drawTimeCallback = null;
  }

  /// 注册回调
  registerCallBack(FpsCallback back) {
    _callBackList.add(back);
  }

  unregisterCallBack(FpsCallback back) {
    _callBackList.remove(back);
  }

  /// 当前帧
  _FpsFrame? _currentFrame;

  /// 帧数的id
  var frameId = 1;
  late FrameCallback beginTimeCallback;
  int? beginCallId;
  FrameCallback? drawTimeCallback;

  _registerListener() {
    beginTimeCallback = (timeStamp) {
      // handle begin frame
      _beginFrame();

      if (drawTimeCallback != null) {
        beginCallId =
            WidgetsBinding.instance!.scheduleFrameCallback(beginTimeCallback);
      }
    };

    // 理论上每一帧应该都是先begin,再draw
    // 那有没有可能是上一针没draw完，下一帧begin开始了
    beginCallId =
        WidgetsBinding.instance!.scheduleFrameCallback(beginTimeCallback);

    drawTimeCallback = (timeStamp) {
      // handle draw frame
      _drawFrame();
    };
    WidgetsBinding.instance!.addPersistentFrameCallback(drawTimeCallback!);
  }

  _beginFrame() {
    if (_currentFrame == null) {
      _currentFrame = _FpsFrame(frameId++, frameStartTime: DateTime.now());
    } else {
      _currentFrame!.clear();
      if (frameId > 10000) frameId = 0;
      _currentFrame!.frameId = frameId++;
      _currentFrame!.frameStartTime = DateTime.now();
    }
  }

  _drawFrame() {
    if (_currentFrame == null || _currentFrame?.frameStartTime == null) {
      DebugLog.instance.log("bindingFps ,error not begin");
      return;
    }

    if ((_currentFrame?.frameId ?? 0) + 1 != frameId) {
      DebugLog.instance
          .log("bindingFps,error not call draw ,but call begin twice");
      return;
    }

    _currentFrame!.frameEndTime = DateTime.now();
    _frameQueue.addFirst(_currentFrame);
  }

  /// 计算fps
  _calFps() async {
    if (_frameQueue.isEmpty) {
      DebugLog.instance.log("bindingFps,NO FRAME");
      return;
    }

    while (_frameQueue.length > _fpsHz!) {
      _frameQueue.removeLast();
    }

    var _calFrameQueue = ListQueue(_frameQueue.length);
    _calFrameQueue.addAll(_frameQueue);
    _frameQueue.clear();
    while (_calFrameQueue.length > _fpsHz!) {
      _calFrameQueue.removeLast();
    }
    double drawFrame = _calFrameQueue.length.toDouble();
    double dropFrameCount = _fpsHz! - drawFrame;
    _callBackList.forEach((callBack) {
      callBack(drawFrame.toDouble(), dropFrameCount.toDouble());
    });
//    DebugLog.instance.log(
//        "BindingFps _fpsHz is $_fpsHz drawFrame is $drawFrame,dropFrameCount is $dropFrameCount");
  }
}

class _FpsFrame {
  DateTime? frameStartTime;
  DateTime? frameEndTime;
  int frameId;

  _FpsFrame(this.frameId, {this.frameStartTime, this.frameEndTime});

  int get frameTime => frameEndTime!.millisecond - frameStartTime!.millisecond;

  clear() {
    frameStartTime = null;
    frameEndTime = null;
    frameId = 0;
  }
}
