import 'package:flutter_just_test/fps/VDFps.dart';
import 'package:flutter_just_test/fps/aliFps.dart';

/// do what
/// @author yulun
/// @since 2020-07-17 19:36
class FpsHelper {
  static FpsHelper _instance;

  static FpsHelper get instance {
    if (_instance == null) {
      _instance = FpsHelper._();
    }
    return _instance;
  }

  FpsHelper._();

  init(){
    aliFps.instance.init();
    aliFps.instance.registerCallBack((fps, dropCount) {
      if (_aliFpsAvg == 0) {
        _aliFpsAvg = fps;
      } else {
        _aliFpsAvg = (fps + _aliFpsAvg) / 2;
      }
    });

    Fps.instance.registerCallBack((fps, dropCount) {
      if (_wdFpsAvg == 0) {
        _wdFpsAvg = fps;
      } else {
        _wdFpsAvg = (fps + _wdFpsAvg) / 2;
      }
    });
  }

  void cancel() {
    aliFps.instance.cancel();
    Fps.instance.cancel();
  }

  double _aliFpsAvg = 0;
  double _wdFpsAvg = 0;

  double get aliFpsAvg => _aliFpsAvg;

  double get wdFpsAvg => _wdFpsAvg;
}
