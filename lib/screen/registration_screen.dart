import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utility/common_widgets/common_scaffold.dart';
import '../../../utility/common_widgets/custom_button.dart';
import '../../../utility/common_widgets/custom_text_field.dart';
import '../../../utility/common_widgets/hidden_text_field.dart';
import '../../../utility/constants/dimens_constants.dart';
import '../controller/registration_controller.dart';

class RegistrationScreen extends StatelessWidget {
  final RegistrationController _controller = Get.put(RegistrationController());

  RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: false,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: Form(
            key: _controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _textFields(),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          textEditingController: _controller.etName,
          hintText: "Full name",
          prefixIcon: Icons.drive_file_rename_outline,
          currentFocusNode: _controller.etNameFocusNode,
          nextFocusNode: _controller.etEmailIdFocusNode,
          validatorFunction: (value) {
            if (value!.isEmpty) {
              return 'Name Cannot Be Empty';
            }
            return null;
          },
        ),
        CustomTextField(
          textEditingController: _controller.etEmailId,
          hintText: "Email Id",
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          currentFocusNode: _controller.etEmailIdFocusNode,
          allowedRegex: "[a-zA-Z0-9@.]",
          validatorFunction: (value) {
            if (value!.isEmpty) {
              return 'Email Cannot Be Empty';
            }
            if (!GetUtils.isEmail(value)) {
              return 'Enter Valid Email';
            }
            return null;
          },
        ),
        CustomHiddenTextField(
          textEditingController: _controller.etPassword,
          hintText: "Password",
          prefixIcon: Icons.lock_outline,
          currentFocusNode: _controller.etPasswordFocusNode,
          validatorFunction: (value) {
            if (value!.isEmpty) {
              return 'Password Cannot Be Empty';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _submitButton() {
    return CustomButton(
      buttonText: 'Register',
      onButtonPressed: () => _controller.onPressButtonRegister(),
    );
  }
}
