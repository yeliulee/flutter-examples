import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linuxman/app.dart';
import 'package:linuxman/service/setting_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SettingService().init(), permanent: true);
  runApp(Application());
}
