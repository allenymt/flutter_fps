import 'package:performance_fps/fps_computer.dart';

/// do what
/// @author yulun
/// @since 2020-07-17 19:36
/// 测试辅助类
class FpsHelper {
  static FpsHelper _instance;

  static FpsHelper get instance {
    if (_instance == null) {
      _instance = FpsHelper._();
    }
    return _instance;
  }

  FpsHelper._();

  bool _start;

  start() {
    if (_start ?? false) return;
    _start = true;
    //需要测试可以再打开
//    BindingFps.instance.start();
//    BindingFps.instance.registerCallBack((fps, dropCount) {
//      if (_bindingFpsAvg == 0) {
//        _bindingFpsAvg = fps;
//      } else {
//        _bindingFpsAvg = (fps + _bindingFpsAvg) / 2;
//      }
//    });

    Fps.instance.registerCallBack((fps, dropCount) {
      if (_computeFpsAvg == 0) {
        _computeFpsAvg = fps;
      } else {
        _computeFpsAvg = (fps + _computeFpsAvg) / 2;
      }
    });
  }

  void cancel() {
//    BindingFps.instance.cancel();
    Fps.instance.cancel();
  }

  double _bindingFpsAvg = 0;
  double _computeFpsAvg = 0;

  double get bindingFpsAvg => _bindingFpsAvg;

  double get computeFpsAvg => _computeFpsAvg;
}
