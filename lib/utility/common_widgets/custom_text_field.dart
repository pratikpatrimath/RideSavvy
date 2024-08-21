import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/dimens_constants.dart';
import '../helper/common_helper.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode? currentFocusNode, nextFocusNode;
  final TextEditingController textEditingController;
  final TextInputType? keyboardType;
  final String hintText;
  final String? instructionText;
  final EdgeInsets? margin;
  final double? height;
  final int? minLines;
  final String? allowedRegex;
  final IconData? prefixIcon, suffixIcon;
  final Color? suffixIconColor;
  final bool? isEnabled, readOnly;
  final String? Function(String?)? validatorFunction;
  final void Function()? onTapField;
  final bool? isWrapContent;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.textEditingController,
    this.instructionText,
    this.margin,
    this.height,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconColor,
    this.currentFocusNode,
    this.nextFocusNode,
    this.allowedRegex,
    this.keyboardType,
    this.isEnabled,
    this.readOnly,
    this.validatorFunction,
    this.onTapField,
    this.isWrapContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    if (isWrapContent != null) {
      if (isWrapContent == true) {
        return Container(
          height: height,
          margin: margin,
          child: _textFormField(),
        );
      }
    }
    return instructionText == null
        ? Container(
            margin: const EdgeInsets.all(DimenConstants.contentPadding),
            child: _textFormField(),
          )
        : Container(
            margin: const EdgeInsets.only(
              top: DimenConstants.contentPadding,
              left: DimenConstants.contentPadding,
              right: DimenConstants.contentPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _textFormField(),
                Text(
                  instructionText ?? "",
                  style: TextStyle(
                    fontSize: Get.textTheme.labelSmall?.fontSize,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _textFormField() {
    return TextFormField(
      cursorHeight: height != null ? (height! / 2) : null,
      focusNode: currentFocusNode,
      controller: textEditingController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        if (allowedRegex != null)
          FilteringTextInputFormatter.allow(RegExp(allowedRegex!)),
      ],
      keyboardType: keyboardType,
      textInputAction: minLines == null ? TextInputAction.done : null,
      readOnly: readOnly ?? false,
      enabled: isEnabled ?? true,
      validator: validatorFunction,
      minLines: minLines ?? 1,
      maxLines: minLines == null ? 1 : null,
      onFieldSubmitted: (_) {
        try {
          currentFocusNode?.unfocus();
          if (nextFocusNode != null) {
            FocusScope.of(
              Get.context as BuildContext,
            ).requestFocus(nextFocusNode);
          }
        } catch (e) {
          CommonHelper.printDebugError(e, "CustomTextFieldWidget line 80");
        }
      },
      decoration: InputDecoration(
        contentPadding: height != null ? EdgeInsets.zero : null,
        labelText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Get.isDarkMode ? Colors.white : ColorConstants.dark,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Icon(
                suffixIcon,
                color: suffixIconColor ??
                    (Get.isDarkMode ? Colors.white : ColorConstants.dark),
              )
            : null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DimenConstants.cardRadius),
          ),
        ),
      ),
      onTap: onTapField,
    );
  }
}
