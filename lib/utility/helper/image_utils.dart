import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'common_helper.dart';

class ImageUtils {
  static Uint8List base64ToImage({required String string}) {
    try {
      return base64Decode(string);
    } catch (e) {
      CommonHelper.printDebugError(e, "ImageUtils line no 16");
    }
    return Uint8List(0);
  }

  static String fileToBase64({required String path}) {
    File file = File(path);
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }

  // static Future<File> createFileFromBase64({
  //   required String base64String,
  // }) async {
  //   Uint8List bytes = base64.decode(base64String);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.jpg");
  //   await file.writeAsBytes(bytes);
  //   return File(file.path);
  // }

  // static Future<String?> pickImageFromGallery() async {
  //   try {
  //     return (await ImagePicker().pickImage(source: ImageSource.gallery))?.path;
  //   } catch (e) {
  //     CommonHelper.printDebugError(e, "ImageUtils line no 42");
  //     SnackBarUtils.errorSnackBar(
  //       title: "ERROR",
  //       message: "Something went wrong. Please try again later",
  //     );
  //   }
  //   return null;
  // }

  // static Future<String?> pickImageFromCamera() async {
  //   try {
  //     return (await ImagePicker().pickImage(source: ImageSource.camera))?.path;
  //   } catch (e) {
  //     CommonHelper.printDebugError(e, "ImageUtils line no 55");
  //     SnackBarUtils.errorSnackBar(
  //       title: "ERROR",
  //       message: "Something went wrong. Please try again later",
  //     );
  //   }
  //   return null;
  // }
}
