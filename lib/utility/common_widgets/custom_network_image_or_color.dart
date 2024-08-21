import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../constants/string_constants.dart';
import '../helper/common_helper.dart';

class CustomNetworkImageOrColor extends StatelessWidget {
  final String? imageString, errorImage;
  final double? imageRadius;

  const CustomNetworkImageOrColor({
    Key? key,
    required this.imageString,
    required this.errorImage,
    this.imageRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageString == null || imageString!.trim().isEmpty) {
      return _defaultBackgroundImage();
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(imageRadius ?? 0),
        child: _imageView(),
      );
    }
  }

  Widget _defaultBackgroundImage() {
    return Image.asset(
      errorImage ?? StringConstants.noImage,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) => Container(),
    );
  }

  Widget _imageView() {
    if (CommonHelper.checkIfFile(string: imageString ?? "")) {
      return _loadFileImage();
    } else if (CommonHelper.checkIfUrl(string: imageString ?? "")) {
      return _loadNetworkImage();
    } else {
      return _loadMemoryImage();
    }
  }

  Widget _loadingIndicator(Widget image) {
    return const Center(child: CircularProgressIndicator(value: 0.5));
  }

  Widget _errorImage() {
    CommonHelper.printDebugError("CustomNetworkImage", "line no 182");
    return Image.asset(
      StringConstants.noImage,
      fit: BoxFit.fill,
      errorBuilder: (_, __, ___) => Container(),
    );
  }

  Widget _loadNetworkImage() {
    return Image.network(
      imageString!,
      fit: BoxFit.cover,
      frameBuilder: (_, image, loadingBuilder, __) {
        return loadingBuilder == null ? _loadingIndicator(image) : image;
      },
      loadingBuilder: (_, image, progress) {
        return _loadingIndicator(image);
      },
      errorBuilder: (_, __, ___) => _errorImage(),
    );
  }

  Image _loadFileImage() {
    return Image.file(
      File(imageString!),
      fit: BoxFit.cover,
      frameBuilder: (_, image, loadingBuilder, __) {
        return loadingBuilder == null ? _loadingIndicator(image) : image;
      },
      errorBuilder: (_, __, ___) => _errorImage(),
    );
  }

  Image _loadMemoryImage() {
    return Image.memory(
      base64ToImage(imageString: imageString!),
      fit: BoxFit.cover,
      frameBuilder: (_, image, loadingBuilder, __) {
        return loadingBuilder == null ? _loadingIndicator(image) : image;
      },
      errorBuilder: (_, __, ___) => _errorImage(),
    );
  }

  static Uint8List base64ToImage({required String imageString}) {
    try {
      return base64Decode(imageString);
    } catch (e) {
      CommonHelper.printDebugError(e, "CustomNetworkImage line no 128");
    }
    return Uint8List(0);
  }
}
