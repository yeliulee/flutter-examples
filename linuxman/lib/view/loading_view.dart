import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text("初始化中...").marginOnly(top: 32),
        ],
      ),
    );
  }
}
