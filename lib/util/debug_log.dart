/// do what
/// @author yulun
/// @since 2020-07-21 19:17
class DebugLog {
  static DebugLog _instance = DebugLog._();

  static DebugLog get instance => _instance;

  bool _debug = true;

  DebugLog._() {
    assert(() {
      _debug = true;
      return true;
    }());
  }

  void log(String message) {
    if (_debug) {
      print(message);
    }
  }
}
