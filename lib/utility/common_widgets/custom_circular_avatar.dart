import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/string_constants.dart';
import '../helper/common_helper.dart';
import '../helper/image_utils.dart';
import 'image_full_screen_wrapper.dart';

class CustomCircularAvatar extends StatelessWidget {
  final double radius;
  final String imageString;
  final String? errorImage;
  final Color? backgroundColor;
  final Function? onTapAvatar;
  final Function? onTapAvatarPhotoLibrary;
  final Function? onTapAvatarCamera;
  final bool? isReadOnly;
  final Rx<bool> isImageLoaded = true.obs;

  CustomCircularAvatar({
    Key? key,
    required this.radius,
    required this.imageString,
    this.errorImage,
    this.backgroundColor,
    this.onTapAvatar,
    this.onTapAvatarPhotoLibrary,
    this.onTapAvatarCamera,
    this.isReadOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isReadOnly == true) {
          Get.to(() => FullScreenPage(imageString: imageString));
        } else {
          _showPicker();
        }
      },
      child: Obx(() {
        return CircleAvatar(
          radius: radius,
          backgroundColor: ColorConstants.accentColor,
          child: isImageLoaded.value
              ? _loadedImage()
              : const CircularProgressIndicator(),
        );
      }),
    );
  }

  Widget _loadedImage() {
    return CircleAvatar(
      radius: radius - 3.5,
      foregroundImage: _foreGroundImage(),
      onForegroundImageError: (_, __) {},
    );
  }

  void _showPicker() {
    showModalBottomSheet(
      backgroundColor: ColorConstants.accentColor,
      context: Get.context!,
      builder: (BuildContext buildContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.fullscreen_outlined,
                  color: Colors.white,
                ),
                title: const Text(
                  'Show Image in full screen',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Get.back();
                  Get.to(() => FullScreenPage(imageString: imageString));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  'Photo Library',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  if (onTapAvatarPhotoLibrary != null) {
                    onTapAvatarPhotoLibrary!();
                  }
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.white),
                title: const Text(
                  'Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  if (onTapAvatarCamera != null) onTapAvatarCamera!();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider<Object> _foreGroundImage() {
    try {
      isImageLoaded.value = false;
      if (imageString == "null" || imageString.isEmpty) {
        isImageLoaded.value = true;
        return AssetImage(errorImage ?? StringConstants.logo);
      } else if (CommonHelper.checkIfFile(string: imageString)) {
        isImageLoaded.value = true;
        return FileImage(File(imageString));
      } else if (CommonHelper.checkIfUrl(string: imageString)) {
        isImageLoaded.value = true;
        return NetworkImage(imageString);
      } else {
        isImageLoaded.value = true;
        return MemoryImage(
          ImageUtils.base64ToImage(string: imageString),
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "CustomCircleAvatar line129");
      isImageLoaded.value = true;
      return AssetImage(errorImage ?? StringConstants.logo);
    }
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
        CommonHelper.printDebugError(error, "CustomCircleAvatar line 193");
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
