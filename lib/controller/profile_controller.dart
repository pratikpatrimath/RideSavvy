import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user_master.dart';
import '../../utility/common_widgets/common_progress.dart';
import '../../utility/constants/string_constants.dart';
import '../../utility/helper/common_helper.dart';
import '../../utility/helper/snack_bar_utils.dart';
import '../../utility/routes/route_constants.dart';
import '../../utility/services/db_helper.dart';
import '../../utility/services/user_pref.dart';
import '../interface/IController.dart';

class ProfileController extends GetxController {
  late TextEditingController etFullName;
  late TextEditingController etEmailId;

  late FocusNode etFullNameFocusNode;
  late IController _controller;

  Rxn<UserMaster> user = Rxn<UserMaster>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initUI();
    initObj();
    fetchProfile();
  }

  void initUI() {
    etFullName = TextEditingController();
    etEmailId = TextEditingController();
    etFullNameFocusNode = FocusNode();
  }

  void initObj() {
    _controller = DbHelper();
  }

  void onTapChangePassword() {
    Get.toNamed(RouteConstants.changePasswordScreen);
  }

  void onPressButtonSubmit() {
    formKey.currentState!.validate() ? _updateProfile() : null;
  }

  Future<void> fetchProfile() async {
    try {
      CommonProgressBar.show();
      int userId = await UserPref.getUserId();
      List<Map<String, dynamic>> responseList = await _controller.getByParam(
        tableName: StringConstants.tableUserMaster,
        colName: StringConstants.userId,
        value: userId.toString(),
      );
      user.value = responseList.map((e) => UserMaster.fromMap(e)).first;
      setDataToField(user: user.value);
    } catch (e) {
      CommonHelper.printDebugError(e, "UserProfileController line no 90");
    } finally {
      CommonProgressBar.hide();
    }
  }

  void setDataToField({UserMaster? user}) {
    etFullName.text = user?.name ?? "";
    etEmailId.text = user?.emailId ?? "";
  }

  UserMaster _createUserObject() {
    String fullName = etFullName.text.trim();

    UserMaster userObj = user.value ?? UserMaster();
    userObj.name = fullName.isNotEmpty ? fullName : null;
    return userObj;
  }

  Future<void> _updateProfile() async {
    try {
      CommonProgressBar.show();
      UserMaster user = _createUserObject();
      int response = await _controller.update(
        entity: user.toMap(),
        id: user.userId.toString(),
        tableName: StringConstants.tableUserMaster,
        colNameForWhereCondition: StringConstants.userId,
      );
      response == -1 ? onFailedResponse() : onSuccessResponse();
    } catch (e) {
      CommonHelper.printDebugError(e, "UserProfileController");
      CommonProgressBar.hide();
      onFailedResponse();
    }
  }

  void onSuccessResponse() async {
    fetchProfile().then(
      (value) {
        SnackBarUtils.normalSnackBar(
          title: "Success",
          message: "Profile updated successfully...",
        );
      },
    );
  }

  void onFailedResponse() {
    SnackBarUtils.errorSnackBar(
      title: "Failed",
      message: "Something went wrong",
    );
  }
}
