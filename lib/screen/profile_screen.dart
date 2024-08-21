import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/common_widgets/custom_text_field.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/profile_controller.dart';
import '../utility/common_widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController _controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(child: _body()),
    );
  }

  Widget _body() {
    return Container(
      constraints: BoxConstraints(minHeight: Get.height, minWidth: Get.width),
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: SingleChildScrollView(
        child: Column(children: [_textFields(), _button()]),
      ),
    );
  }

  Widget _textFields() {
    return Form(
      key: _controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextField(
            textEditingController: _controller.etFullName,
            hintText: "Full Name",
            prefixIcon: Icons.edit_outlined,
            currentFocusNode: _controller.etFullNameFocusNode,
            validatorFunction: (value) {
              if (value!.isEmpty) {
                return 'Full Name Cannot Be Empty';
              }
              return null;
            },
          ),
          CustomTextField(
            textEditingController: _controller.etEmailId,
            hintText: "Email Id",
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            suffixIcon: Icons.check_circle,
            suffixIconColor: Colors.green,
            readOnly: true,
          ),
          const SizedBox(height: DimenConstants.contentPadding),
        ],
      ),
    );
  }

  Widget _button() {
    return Column(
      children: [
        CustomButton(
          buttonText: "Submit",
          onButtonPressed: () => _controller.onPressButtonSubmit(),
        ),
        InkWell(
          onTap: () => _controller.onTapChangePassword(),
          child: const Padding(
            padding: EdgeInsets.all(DimenConstants.layoutPadding),
            child: Text(
              'CHANGE PASSWORD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        )
      ],
    );
  }
}
