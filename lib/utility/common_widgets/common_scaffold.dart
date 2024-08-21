import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget body;

  const CommonScaffold({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    context.theme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: GestureDetector(
        child: SafeArea(child: body),
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
