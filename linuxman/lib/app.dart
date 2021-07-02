import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linuxman/view/home_view.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onGlobalTap(context),
      child: GetMaterialApp(
        title: "Linux 指令手册",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeView(),
      ),
    );
  }

  void onGlobalTap(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
