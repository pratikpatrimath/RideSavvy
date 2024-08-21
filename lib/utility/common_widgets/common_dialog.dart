import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonDialog extends StatelessWidget {
  final Widget contentWidget;
  final String title, positiveDialogBtnText;
  final String? negativeRedDialogBtnText;
  final Function()? onNegativeRedBtnClicked, onPositiveButtonClicked;

  const CommonDialog({
    Key? key,
    required this.title,
    required this.contentWidget,
    required this.positiveDialogBtnText,
    this.negativeRedDialogBtnText,
    this.onPositiveButtonClicked,
    this.onNegativeRedBtnClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: contentWidget,
      actions: <Widget?>[
        negativeRedDialogBtnText != null ? negativeButton() : null,
        CupertinoDialogAction(
          onPressed: onPositiveButtonClicked ?? () => Get.back(),
          child: Text(positiveDialogBtnText),
        ),
      ].whereType<Widget>().toList(),
    );
  }

  Widget negativeButton() {
    return CupertinoDialogAction(
      isDefaultAction: true,
      onPressed: onNegativeRedBtnClicked ?? () => Get.back(),
      child: Text(
        negativeRedDialogBtnText!,
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
