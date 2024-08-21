import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user_master.dart';
import '../../utility/common_widgets/common_progress.dart';
import '../../utility/helper/common_helper.dart';
import '../../utility/helper/snack_bar_utils.dart';
import '../../utility/routes/route_constants.dart';
import '../../utility/services/db_helper.dart';
import '../interface/ILoginController.dart';

class RegistrationController extends GetxController {
  late TextEditingController etName;
  late TextEditingController etEmailId;
  late TextEditingController etPassword;

  late FocusNode etNameFocusNode;
  late FocusNode etEmailIdFocusNode;
  late FocusNode etPasswordFocusNode;
  late ILoginController _controller;

  RxBool isValidEmail = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Future<void> onInit() async {
    super.onInit();
    initUI();
    initListeners();
    await initObj();
  }

  void initUI() {
    etName = TextEditingController();
    etEmailId = TextEditingController();
    etPassword = TextEditingController();

    etNameFocusNode = FocusNode();
    etEmailIdFocusNode = FocusNode();
    etPasswordFocusNode = FocusNode();
  }

  void initListeners() {
    etEmailId.addListener(() {
      isValidEmail.value = etEmailId.text.isEmail;
    });
  }

  Future<void> initObj() async {
    _controller = DbHelper();
  }

  void onPressButtonRegister() {
    formKey.currentState!.validate() ? _register() : null;
  }

  UserMaster _createUserObject() {
    UserMaster user = UserMaster();
    user.name = etName.text.toString().trim();
    user.emailId = etEmailId.text.toString().trim();
    user.password = etPassword.text.toString().trim();
    return user;
  }

  Future<void> _register() async {
    try {
      CommonProgressBar.show();
      UserMaster user = _createUserObject();
      String response = await _controller.register(entity: user);
      response.toLowerCase() == 'success'
          ? onRegistrationSuccess(user: user)
          : onRegistrationFailed(response);
    } catch (e) {
      CommonHelper.printDebugError(e, "RegistrationGoalController line 66");
      onRegistrationFailed(e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onRegistrationSuccess({required UserMaster user}) async {
    Get.offAllNamed(RouteConstants.loginScreen);
  }

  void onRegistrationFailed(String? error) {
    if (error != null && error.toLowerCase().contains("already")) {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Email Id already exist",
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Something went wrong",
      );
    }
  }
}
