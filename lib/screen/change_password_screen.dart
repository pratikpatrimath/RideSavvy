import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_dialog.dart';
import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/common_widgets/custom_button.dart';
import '../../utility/common_widgets/hidden_text_field.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final ChangePasswordController _controller =
      Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
        appBar: AppBar(title: const Text('Change Password')),
        body: CommonScaffold(body: SafeArea(child: Center(child: _body()))));
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_enterPasswordDetailsCard()],
          ),
        ),
      ),
    );
  }

  Widget _enterPasswordDetailsCard() {
    return Card(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      elevation: DimenConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimenConstants.mainCardRadius),
      ),
      child: Container(
        padding: const EdgeInsets.only(
          top: DimenConstants.layoutPadding,
          bottom: DimenConstants.layoutPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _passwordDetailsCardTextFields(),
            _passwordDetailsCardButtons(),
          ],
        ),
      ),
    );
  }

  Widget _passwordDetailsCardTextFields() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Form(
        key: _controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomHiddenTextField(
              textEditingController: _controller.etOldPassword,
              hintText: "Old Password",
              prefixIcon: Icons.key_outlined,
              currentFocusNode: _controller.etOldPasswordFocusNode,
              nextFocusNode: _controller.etNewPasswordFocusNode,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Old Password Cannot Be Empty';
                }
                return null;
              },
            ),
            CustomHiddenTextField(
              textEditingController: _controller.etNewPassword,
              hintText: "New Password",
              prefixIcon: Icons.password_outlined,
              currentFocusNode: _controller.etNewPasswordFocusNode,
              nextFocusNode: _controller.etConfirmNewPasswordFocusNode,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'New Password Cannot Be Empty';
                }
                return null;
              },
            ),
            CustomHiddenTextField(
              textEditingController: _controller.etConfirmNewPassword,
              hintText: "Confirm New Password",
              prefixIcon: Icons.password_outlined,
              isObscureTextIconDisabled: true,
              currentFocusNode: _controller.etConfirmNewPasswordFocusNode,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Field Cannot Be Empty';
                }
                String pass = _controller.etNewPassword.text.toString().trim();
                if (value.toString().trim() != pass) {
                  return "Password doesn't match";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordDetailsCardButtons() {
    return CustomButton(
      buttonText: "Submit",
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      onButtonPressed: () => {
        if (_controller.formKey.currentState!.validate())
          Get.dialog(_confirmChangePasswordDialog()),
      },
    );
  }

  Widget _confirmChangePasswordDialog() {
    return CommonDialog(
      title: "Change Password",
      contentWidget: const Text(
        "\nAre you sure you want to change password ?"
        " You will be log out of the app once you change the password.\n",
      ),
      negativeRedDialogBtnText: "Confirm",
      positiveDialogBtnText: "Back",
      onNegativeRedBtnClicked: () => _controller.onConfirmChangePassword(),
    );
  }
}
