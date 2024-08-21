import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../common_widgets/common_dialog.dart';
import 'snack_bar_utils.dart';

class CommonHelper {
  static void printDebugError(Object? error, String errorFileNameAndLine) {
    String text;
    if (error == null) {
      text = "ERROR :- Something went wrong";
    } else {
      String errorLine = "ErrorFileName And Line : $errorFileNameAndLine";
      text = "ERROR :- $error \n $errorLine";
    }
    debugPrint('\x1B[31m$text\x1B[0m');
  }

  static void printDebug(Object? message) {
    if (message != null) {
      String text = message.toString();
      debugPrint('\x1B[33m$text\x1B[0m');
    }
  }

  static Future<Uint8List?> getBytesFromAsset({
    required String path,
    int? size,
  }) async {
    try {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: size ?? 120,
      );
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
          ?.buffer
          .asUint8List();
    } catch (e) {
      CommonHelper.printDebugError(e, "CommonHelper getBytesFromAsset()");
      return null;
    }
  }

  static removeTrailingZeros(String n) {
    return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }

  static bool checkIfUrl({required String string}) {
    try {
      Uri? uri = Uri.tryParse(string.toString());
      if (uri?.hasAbsolutePath == true) {
        RegExp regexExp =
            RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
        Iterable<RegExpMatch> urlMatches = regexExp.allMatches(string);
        return urlMatches.isNotEmpty ? true : false;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static bool checkIfFile({required String string}) {
    try {
      File file = File(string);
      return file.existsSync();
    } catch (e) {
      return false;
    }
  }

  static List<String>? getLinkFromMessage({required String message}) {
    try {
      Uri? uri = Uri.tryParse(message.toString());
      if (uri?.hasAbsolutePath == true) {
        RegExp regexExp =
            RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
        Iterable<RegExpMatch> urlMatches = regexExp.allMatches(message);
        return urlMatches
            .map((urlMatch) => message.substring(urlMatch.start, urlMatch.end))
            .toList();
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<bool> getInternetStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        printDebug('Internet is connected');
        return true;
      }
    } catch (_) {
      SnackBarUtils.errorSnackBar(
        title: "ERROR",
        message: "Internet connection not found. Please try again later",
      );
      printDebug('Internet is not connected');
    }
    return false;
  }

  static confirmationDialog({
    String? title,
    required String confirmationText,
    required Function onConfirm,
  }) {
    Get.dialog(
      CommonDialog(
        title: title ?? confirmationText,
        contentWidget: Text("Are you sure you want to $confirmationText"),
        negativeRedDialogBtnText: "Confirm",
        positiveDialogBtnText: "Back",
        onNegativeRedBtnClicked: () {
          Get.back();
          onConfirm();
        },
      ),
    );
  }
}
