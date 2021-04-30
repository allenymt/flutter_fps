import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'fps_helper.dart';

/// do what
/// @author yulun
/// @since 2020-07-17 14:51
/// 尽量在profile模式下测试 ，并且打开performance比对
class TestFpsWidget extends StatefulWidget {
  @override
  State createState() {
    return TestFpsState();
  }
}

class TestFpsState extends State<TestFpsWidget> {
  int _currentFps;
  FrameCallback callback;

  @override
  initState() {
    super.initState();
    callback = (timeStamp) {
      if (mounted) {
        setState(() {
          _currentFps = FpsHelper.instance.computeFpsAvg?.floor();
        });
      }
    };
    SchedulerBinding.instance.addPersistentFrameCallback(callback);
    FpsHelper.instance.start();
  }

  @override
  dispose() {
    super.dispose();
    FpsHelper.instance.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: EdgeInsets.all(8),
          children: List.generate(300, (index) {
            return Stack(
              children: <Widget>[
                Text('$index'),
              ],
            );
          }),
        ),
        Positioned(
            right: 10,
            top: 10,
            child: Text(
              "fps:$_currentFps",
              style: TextStyle(color: Colors.red,fontSize: 20),
            ))
      ],
    );
  }
}
