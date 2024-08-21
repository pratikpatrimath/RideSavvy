import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';

class CustomObjectDropDown<T> extends StatelessWidget {
  final List<T> objectList;
  final String hintText;
  final bool? isAddCompulsoryFieldAsteriskSign;
  final bool? isReadOnly;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Rxn<T?> selected;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validatorFunction;
  final String Function(T)? displayTextFunction;
  final bool Function(T?, T?)? objectsEqualFunction;

  const CustomObjectDropDown({
    Key? key,
    required this.hintText,
    this.isAddCompulsoryFieldAsteriskSign,
    this.isReadOnly,
    this.prefixIcon,
    this.suffixIcon,
    required this.objectList,
    required this.selected,
    this.onChanged,
    this.validatorFunction,
    this.displayTextFunction,
    this.objectsEqualFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return Center(
      child: Obx(() {
        T? selectedValue = selected.value;
        T? selectedObject = objectList.firstWhereOrNull(
          (item) => objectsEqualFunction?.call(item, selectedValue) ?? false,
        );
        return Container(
          margin: const EdgeInsets.all(DimenConstants.contentPadding),
          child: DropdownButtonFormField<T>(
            value: selectedObject,
            validator: validatorFunction,
            onChanged: isReadOnly != null && isReadOnly == true
                ? null
                : (value) {
                    onChanged != null ? onChanged!(value) : setSelected(value);
                  },
            isExpanded: true,
            focusNode: focusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              label: isAddCompulsoryFieldAsteriskSign == true
                  ? Text.rich(
                      TextSpan(
                        text: hintText,
                        children: const <InlineSpan>[
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    )
                  : Text(hintText),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(DimenConstants.cardRadius),
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(DimenConstants.textFieldCornerRadius),
                ),
              ),
            ),
            items: objectList.map(
              (value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(
                    displayTextFunction != null
                        ? displayTextFunction!(value)
                        : value.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ).toList(),
          ),
        );
      }),
    );
  }

  void setSelected(T? value) {
    if (value != null) {
      if (isReadOnly == null || isReadOnly != true) {
        selected.value = value;
      }
    }
  }
}
