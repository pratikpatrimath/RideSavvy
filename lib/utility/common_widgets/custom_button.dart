import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';

class CustomButton extends StatelessWidget {
  final String? buttonText;
  final Function onButtonPressed;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadiusGeometry? radius;
  final Widget? iconWidget;
  final Color? textColor;
  final Color? buttonColor;
  final Color? foreGroundColor;
  final Color? primaryColor;
  final FocusNode? currentFocusNode;
  final bool? isWrapContent;
  final bool? isTransparentButton;
  final TextDirection? textDirection;
  final Color? splashColor;

  const CustomButton({
    Key? key,
    this.buttonText,
    required this.onButtonPressed,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.radius,
    this.iconWidget,
    this.textColor,
    this.buttonColor,
    this.foreGroundColor,
    this.primaryColor,
    this.currentFocusNode,
    this.isWrapContent,
    this.isTransparentButton,
    this.textDirection,
    this.splashColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTransparentButton != null || isWrapContent != null) {
      if (isTransparentButton == true || isWrapContent == true) {
        return Container(
          margin: margin ?? const EdgeInsets.all(0.0),
          padding: padding ?? const EdgeInsets.all(0.0),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: width,
              height: height ?? 50,
            ),
            child: _body(),
          ),
        );
      }
    }
    return Container(
      margin: margin ?? const EdgeInsets.all(DimenConstants.contentPadding),
      padding: padding ?? const EdgeInsets.all(DimenConstants.layoutPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: width ?? Get.size.width * 0.8,
          height: 50,
        ),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    if (buttonText != null && iconWidget != null) {
      return _buttonWithIconAndText();
    } else if (buttonText != null) {
      return _buttonWithText();
    } else if (iconWidget != null) {
      return _buttonWithIcon();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buttonWithIconAndText() {
    return ElevatedButton.icon(
      icon: iconWidget!,
      label: Text(
        buttonText!.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Get.height * 0.02,
          color: textColor,
        ),
      ),
      onPressed: () => onButtonPressed(),
      style: _buttonStyle(),
    );
  }

  Widget _buttonWithText() {
    return ElevatedButton(
      onPressed: () => onButtonPressed(),
      style: _buttonStyle(),
      child: Text(
        buttonText!.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Get.height * 0.02,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buttonWithIcon() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius ??
            (isTransparentButton == true
                ? BorderRadius.zero
                : BorderRadius.circular(DimenConstants.cardRadius)),
        color: isTransparentButton == true ? Colors.transparent : buttonColor,
        border: Border.all(
          color: isTransparentButton == true
              ? primaryColor ?? Colors.transparent
              : primaryColor ?? Get.theme.primaryColor,
        ),
      ),
      child: IconButton(
        icon: iconWidget!,
        onPressed: () => onButtonPressed(),
        color: isTransparentButton == true
            ? primaryColor ?? Colors.transparent
            : primaryColor ?? Get.theme.primaryColor,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      elevation:
          isTransparentButton == true ? MaterialStateProperty.all(0.0) : null,
      backgroundColor: isTransparentButton == true
          ? MaterialStateProperty.all(Colors.transparent)
          : buttonColor != null
              ? MaterialStateProperty.all(buttonColor)
              : null,
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: radius ??
              (isTransparentButton == true
                  ? BorderRadius.zero
                  : BorderRadius.circular(DimenConstants.cardRadius)),
          side: BorderSide(
            color: isTransparentButton == true
                ? primaryColor ?? Colors.transparent
                : primaryColor ?? Get.theme.primaryColor,
          ),
        ),
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return splashColor ?? Colors.transparent;
          }
          return null;
        },
      ),
    );
  }
}
