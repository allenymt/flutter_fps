import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'FpsHelper.dart';

/// do what
/// @author yulun
/// @since 2020-07-17 14:51
class TestFpsWidget extends StatefulWidget {
  @override
  State createState() {
    return TestFpsState();
  }
}

class TestFpsState extends State<TestFpsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Container(
            constraints: BoxConstraints.tightFor(width: 100, height: 50),
            alignment: Alignment.center,
            child: Text("open fps"),
            color: Colors.red,
          ),
          onTap: () {
            FpsHelper.instance.init();
          },
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          child: Container(
            constraints: BoxConstraints.tightFor(width: 100, height: 50),
            alignment: Alignment.center,
            child: Text("close fps"),
            color: Colors.green,
          ),
          onTap: () {
            FpsHelper.instance.cancel();
          },
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          child: Container(
            constraints: BoxConstraints.tightFor(width: 300, height: 50),
            alignment: Alignment.center,
            child: Text(
                "aliFps is ${FpsHelper.instance.aliFpsAvg}, wdFps is ${FpsHelper.instance.wdFpsAvg}"),
            color: Colors.deepOrange,
          ),
          onTap: () {
            setState(() {});
          },
        ),
      ],
    );
  }
}
