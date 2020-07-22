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
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only(top: 20,bottom: 20),
            alignment: Alignment.center,
            child: Text(
              "open fps",
              style: TextStyle(color: Colors.black),
            ),
            color: Colors.black12,
          ),
          onTap: () {
            FpsHelper.instance.start();
          },
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only(top: 20,bottom: 20),
            alignment: Alignment.center,
            child: Text(
              "close fps",
              style: TextStyle(color: Colors.black),
            ),
            color: Colors.black12,
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
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only(top: 20,bottom: 20),
            alignment: Alignment.center,
            child: Text(
                "bindingFps is ${FpsHelper.instance.bindingFpsAvg?.floor()}, computerFps is ${FpsHelper.instance.computeFpsAvg?.floor()}"),
            color: Colors.black12,
          ),
          onTap: () {
            setState(() {});
          },
        ),
      ],
    );
  }
}
