import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linuxman/constant/menu_action.dart';
import 'package:linuxman/controller/app_controller.dart';
import 'package:linuxman/view/loading_view.dart';

class HomeView extends GetView<AppController> {
  HomeView() {
    Get.put(AppController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Linux 指令手册"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: controller.onMenuSelected,
            itemBuilder: (_) => [
              PopupMenuItem<MenuAction>(
                value: MenuAction.about,
                child: Text("关于软件"),
              ),
              PopupMenuItem<MenuAction>(
                value: MenuAction.official,
                child: Text("开源仓库"),
              ),
              PopupMenuItem<MenuAction>(
                value: MenuAction.credits,
                child: Text("开源授权"),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16).copyWith(bottom: 0),
        child: FutureBuilder(
          future: controller.loadResource(),
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData || !snapshot.data!) {
              return LoadingView();
            } else {
              return Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "请输入 Linux 指令",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: controller.search,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      child: SafeArea(
                        child: Obx(
                          () => ListView.builder(
                            itemCount: controller.filteredData.length,
                            itemBuilder: (_, int index) {
                              var detail = controller.filteredData[index];
                              return ListTile(
                                title: Text(
                                  "${detail["n"]} : ${detail["d"]}",
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () => controller.onClickItem(index),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
