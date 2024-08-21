import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_dialog.dart';
import '../../utility/common_widgets/common_progress.dart';
import '../../utility/helper/common_helper.dart';
import '../../utility/helper/snack_bar_utils.dart';
import '../../utility/routes/route_constants.dart';
import '../../utility/services/user_pref.dart';
import '../interface/IController.dart';
import '../model/user_master.dart';
import '../utility/constants/string_constants.dart';
import '../utility/services/db_helper.dart';

class ChangePasswordController extends GetxController {
  late TextEditingController etOldPassword;
  late TextEditingController etNewPassword;
  late TextEditingController etConfirmNewPassword;
  late FocusNode etOldPasswordFocusNode;
  late FocusNode etNewPasswordFocusNode;
  late FocusNode etConfirmNewPasswordFocusNode;
  late IController controller;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initUI();
    initObj();
  }

  void initUI() {
    etOldPassword = TextEditingController();
    etNewPassword = TextEditingController();
    etConfirmNewPassword = TextEditingController();

    etOldPasswordFocusNode = FocusNode();
    etNewPasswordFocusNode = FocusNode();
    etConfirmNewPasswordFocusNode = FocusNode();
  }

  void initObj() {
    controller = DbHelper();
  }

  Future<void> onConfirmChangePassword() async {
    try {
      changePassword();
    } catch (e) {
      onChangePasswordFailed(error: e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  Future<void> changePassword() async {
    try {
      CommonProgressBar.show();
      int userId = await UserPref.getUserId();
      String oldPassword = etOldPassword.text.trim();
      String newPassword = etNewPassword.text.trim();

      List<Map<String, dynamic>> responseList = await controller.getByParam(
        tableName: StringConstants.tableUserMaster,
        whereClause: '${StringConstants.userId} = \'$userId\' '
            'AND ${StringConstants.password} = \'$oldPassword\'',
      );
      if (responseList.isNotEmpty) {
        UserMaster user = responseList.map((e) => UserMaster.fromMap(e)).first;
        user.password = newPassword;
        int response = await controller.update(
          entity: user.toMap(),
          id: user.userId.toString(),
          tableName: StringConstants.tableUserMaster,
          colNameForWhereCondition: StringConstants.userId,
        );
        response == -1 ? onChangePasswordFailed() : onChangePasswordSuccess();
      } else {
        onChangePasswordFailed(error: "false");
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ChangePasswordController line 85");
      onChangePasswordFailed(error: e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onChangePasswordSuccess() {
    Get.back();
    Get.dialog(
      CommonDialog(
        title: "Success",
        contentWidget: const Text(
          "Password Changed Successfully,"
          "\n Need to login again!!!",
        ),
        positiveDialogBtnText: "Ok",
        onPositiveButtonClicked: () async {
          UserPref.removeAllFromUserPref();
          Get.offAllNamed(RouteConstants.loginScreen);
        },
      ),
      barrierDismissible: false,
    );
  }

  void onChangePasswordFailed({String? error}) {
    CommonHelper.printDebugError(error, "ChangePasswordController line 111");
    Get.back();
    String onError = error ?? "";
    if (onError == "false") {
      Get.dialog(
        const CommonDialog(
          title: "Password Incorrect!!!",
          contentWidget: Text(
            "Enter Correct Password And"
            "\nTry Again Later",
          ),
          positiveDialogBtnText: "Ok",
        ),
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Something went wrong. Please try again later'",
      );
    }
  }
}
