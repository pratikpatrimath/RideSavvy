import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/user_master.dart';
import '../../utility/common_widgets/common_progress.dart';
import '../../utility/helper/common_helper.dart';
import '../../utility/helper/snack_bar_utils.dart';
import '../../utility/routes/route_constants.dart';
import '../../utility/services/db_helper.dart';
import '../../utility/services/user_pref.dart';
import '../interface/ILoginController.dart';

class LoginController extends GetxController {
  late TextEditingController etEmailId;
  late TextEditingController etPassword;

  late FocusNode etEmailIdFocusNode;
  late FocusNode etPasswordFocusNode;
  late ILoginController iLoginController;

  RxBool isValidEmail = false.obs;
  RxBool isPermissionGranted = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Future<void> onInit() async {
    super.onInit();
    initUI();
    initListeners();
    await initObj();
  }

  void initUI() {
    etEmailId = TextEditingController();
    etPassword = TextEditingController();
    etEmailIdFocusNode = FocusNode();
    etPasswordFocusNode = FocusNode();
  }

  void initListeners() {
    etEmailId.addListener(() {
      isValidEmail.value = etEmailId.text.isEmail;
    });
  }

  Future<void> initObj() async {
    iLoginController = DbHelper();
  }

  void onTapSignUp() {
    Get.toNamed(RouteConstants.registrationScreen);
  }

  Future<void> onPressButtonLogin() async {
    if (formKey.currentState!.validate()) {
      await _checkPermissionStatus();
      login();
    }
  }

  Future<void> login() async {
    try {
      CommonProgressBar.show();
      UserMaster? user = await iLoginController.login(
        emailId: etEmailId.text.trim(),
        password: etPassword.text.trim(),
      );
      user != null ? onLoginSuccess(user: user) : onLoginFailed("false");
    } catch (e) {
      CommonHelper.printDebugError(e, "LoginGoalController line 66");
      onLoginFailed(e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onLoginSuccess({required UserMaster user}) async {
    UserPref.setUserIdAndName(
      userId: user.userId ?? -1,
      name: user.name ?? "-1",
    );
    Get.offAllNamed(RouteConstants.homeScreen);
  }

  void onLoginFailed(String? error) {
    if (error != null &&
        (error.toLowerCase().contains("false") ||
            error.toLowerCase().contains("incorrect"))) {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Invalid Email Id or Password",
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Something went wrong",
      );
    }
  }

  Future<void> checkPermissionStatus(Permission permission) async {
    final status = await permission.status;
    isPermissionGranted.value = status.isGranted;
  }

  Future<void> _checkPermissionStatus() async {
    try {
      final permissionsToCheck = [Permission.location];

      for (final permission in permissionsToCheck) {
        await checkPermissionStatus(permission);
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "BluetoothController onInit()");
      isPermissionGranted.value = false;
    }
  }
}
