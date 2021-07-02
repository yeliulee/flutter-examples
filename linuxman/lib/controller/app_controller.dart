import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linuxman/constant/menu_action.dart';
import 'package:linuxman/service/setting_service.dart';
import 'package:linuxman/view/detail_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppController extends GetxController {
  static const String CACHE_KEY = "app_linux_man_res_extracted";
  SettingService settingService = SettingService.it;
  bool resourceLoaded = false;
  bool resourceExtracted = false;
  Map<String, dynamic> indexData = {};
  Map<String, dynamic> currentCommand = Map<String, dynamic>();
  RxList<Map<String, dynamic>> _filteredData = RxList<Map<String, dynamic>>();

  List<Map<String, dynamic>> get filteredData => _filteredData.toList();

  @override
  void onInit() {
    super.onInit();
    registerLicenses();
    resourceExtracted = settingService.getBool(CACHE_KEY, false);
  }

  /// 获取资源文件夹
  Future<Directory> getResourceDir() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    Directory resDir = Directory("${docDir.path}/linux-man");
    if (!resDir.existsSync()) {
      resDir.createSync();
    }
    return resDir;
  }

  /// 加载资源
  Future<bool> loadResource() async {
    if (resourceLoaded && resourceExtracted) {
      await Future.delayed(Duration(milliseconds: 1000));
      return true;
    }
    try {
      String resDirPath = (await getResourceDir()).path;
      if (!resourceExtracted) {
        ByteData byteData = await rootBundle.load("assets/linux-man.zip");
        Uint8List zipBytes = byteData.buffer.asUint8List();
        Archive archivedFiles = ZipDecoder().decodeBytes(zipBytes);
        for (ArchiveFile file in archivedFiles) {
          Uint8List fileData = file.content as Uint8List;
          String filePath = "$resDirPath/${file.name}";
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileData);
        }
        resourceExtracted = true;
        settingService.instance!.setBool(CACHE_KEY, true);
      }
      if (!resourceLoaded) {
        String indexJSON = File("$resDirPath/index.json").readAsStringSync();
        indexData = jsonDecode(indexJSON);
        resourceLoaded = true;
      }
      return true;
    } catch (e) {
      Future.delayed(Duration(milliseconds: 500), () async {
        Get.back();
        Get.snackbar(
          "错误提示",
          "Linux 手册索引数据加载失败...",
          snackPosition: SnackPosition.BOTTOM,
        );
        await Future.delayed(Duration(milliseconds: 500), () => exit(0));
      });
    }
    return false;
  }

  /// 过滤搜索
  void search(String text) {
    if (text.trim().isEmpty) {
      _filteredData.clear();
      return;
    }
    var filtered = indexData.entries.where((item) {
      return item.key.contains(text.toLowerCase()) ||
          item.value["d"].toLowerCase().contains(text.toLowerCase());
    });
    List<Map<String, dynamic>> items = [];
    filtered.forEach((item) {
      items.add(item.value);
    });
    _filteredData.assignAll(items);
  }

  void onClickItem(int index) async {
    FocusManager.instance.primaryFocus?.unfocus();
    String name = filteredData[index]["n"];
    String resDirPath = (await getResourceDir()).path;
    String detail = File("$resDirPath/$name.md").readAsStringSync();
    currentCommand = {
      "name": "$name 文档",
      "detail": detail,
    };
    Future.delayed(Duration(milliseconds: 200), () {
      Get.to(() => DetailView());
    });
  }

  void onMenuSelected(MenuAction action) {
    switch (action) {
      case MenuAction.about:
        showAboutDialog(
          context: Get.context!,
          applicationLegalese: "随时随地方便地查询 Linux 指令文档.",
        );
        break;
      case MenuAction.official:
        launch("https://github.com/yeliulee/flutter-examples/linuxman");
        break;
      case MenuAction.credits:
        showLicensePage(
          context: Get.context!,
          applicationLegalese: "随时随地方便地查询 Linux 指令文档 (MIT License)",
        );
        break;
      default:
    }
  }

  void registerLicenses() {
    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(["linux-command"], """
MIT License

Copyright © 2019 小弟调调™

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.""");
    });
  }
}
