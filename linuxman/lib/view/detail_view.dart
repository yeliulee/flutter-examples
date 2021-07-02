import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:linuxman/controller/app_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailView extends GetView<AppController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.currentCommand["name"]),
      ),
      body: Container(
        padding: EdgeInsets.all(16).copyWith(bottom: 0),
        child: SafeArea(
          child: Markdown(
            data: controller.currentCommand["detail"],
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              codeblockDecoration: BoxDecoration(
                color: Colors.black12.withOpacity(0.1),
              ),
              code: TextStyle(
                backgroundColor: Colors.transparent,
              ),
              codeblockAlign: WrapAlignment.start,
            ),
            onTapLink: (_, String? href, __) => launch(href!),
          ),
        ),
      ),
    );
  }
}
