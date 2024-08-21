import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarUtils {
  static normalSnackBar({required String title, required String message}) {
    Get.context?.theme;
    return Get.snackbar(
      title,
      message,
      colorText: Get.theme.primaryColor,
      backgroundColor: Colors.white,
    );
  }

  static errorSnackBar({required String title, required String message}) {
    return Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }
}
