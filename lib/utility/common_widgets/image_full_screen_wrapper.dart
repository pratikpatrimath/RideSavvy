import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/string_constants.dart';
import '../helper/common_helper.dart';
import '../helper/image_utils.dart';

class FullScreenPage extends StatelessWidget {
  const FullScreenPage({super.key, required this.imageString});

  final String imageString;

  @override
  Widget build(BuildContext context) {
    context.theme;
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: Get.height, minWidth: Get.width),
        child: Stack(
          children: [
            Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 333),
                  curve: Curves.fastOutSlowIn,
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4,
                    child: _imageView(),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    color: Get.isPlatformDarkMode
                        ? Colors.black12
                        : Colors.white70,
                    highlightElevation: 0,
                    minWidth: double.minPositive,
                    height: double.minPositive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, size: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Image _imageView() {
    return CommonHelper.checkIfFile(string: imageString)
        ? _loadFileImage()
        : CommonHelper.checkIfUrl(string: imageString)
            ? _loadNetworkImage()
            : _loadMemoryImage();
  }

  Image _loadNetworkImage() {
    return Image.network(
      imageString,
      fit: BoxFit.fill,
      frameBuilder: (_, image, loadingBuilder, __) {
        if (loadingBuilder == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return image;
      },
      loadingBuilder: (_, image, progress) {
        if (progress == null) return image;
        return Center(
          child: CircularProgressIndicator(
            value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        CommonHelper.printDebugError(error, "CustomCircleAvatar line163");
        return Image.asset(
          StringConstants.noImage,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => Container(),
        );
      },
    );
  }

  Image _loadFileImage() {
    return Image.file(
      File(imageString),
      fit: BoxFit.fill,
      frameBuilder: (_, image, loadingBuilder, __) {
        if (loadingBuilder == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return image;
      },
      errorBuilder: (context, error, stackTrace) {
        CommonHelper.printDebugError(error, "CustomCircleAvatar line120");
        return Image.asset(
          StringConstants.noImage,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => Container(),
        );
      },
    );
  }

  Image _loadMemoryImage() {
    return Image.memory(
      ImageUtils.base64ToImage(string: imageString.toString()),
      fit: BoxFit.fill,
      frameBuilder: (_, image, loadingBuilder, __) {
        if (loadingBuilder == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return image;
      },
      errorBuilder: (context, error, stackTrace) {
        CommonHelper.printDebugError(error, "CustomCircleAvatar line205");
        return Image.asset(
          StringConstants.noImage,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => Container(),
        );
      },
    );
  }
}
