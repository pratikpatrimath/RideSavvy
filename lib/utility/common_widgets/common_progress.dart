import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constants/string_constants.dart';
import '../helper/common_helper.dart';

class CommonProgressBar {
  static OverlayEntry? _progressOverlayEntry;

  static void show() {
    try {
      final context = Get.overlayContext;
      if (context != null) {
        hide();
        _progressOverlayEntry = _createProgressEntry(context);
        Overlay.of(context).insert(_progressOverlayEntry!);
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "CommonProgressWidget line 17");
    }
  }

  static void hide() {
    try {
      if (_progressOverlayEntry != null) {
        _progressOverlayEntry?.remove();
        _progressOverlayEntry = null;
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "CommonProgressWidget line 28");
    }
  }

  static OverlayEntry _createProgressEntry(BuildContext context) {
    return OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Container(color: Colors.black54),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Lottie.asset(
                  StringConstants.loadingLottie,
                  height: Get.width / 3,
                  errorBuilder: (context, error, stackTrace) {
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
