import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../common_widgets/common_dialog.dart';

class GpsUtils {
  static Rx<LocationPermission> permission = Rx(LocationPermission.denied);

  static Future<LocationPermission> requestPermission() async {
    permission.value = await Geolocator.requestPermission();
    return permission.value;
  }

  static Future<bool> requestLocation() async {
    await requestPermission();
    if (permission.value == LocationPermission.deniedForever) {
      showSettingsDialog();
      return false;
    }
    if (permission.value == LocationPermission.denied) {
      await requestPermission();
      if (permission.value != LocationPermission.whileInUse ||
          permission.value != LocationPermission.always) {
        return true;
      }
    }
    return false;
  }

  static Future<Position?>? getCurrentLocation() async {
    requestLocation();
    if (permission.value == LocationPermission.whileInUse ||
        permission.value == LocationPermission.always) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }
    return null;
  }

  static String getStringFromLatLng({required LatLng latLng}) {
    double latitude = latLng.latitude;
    double longitude = latLng.longitude;
    return "$latitude,$longitude";
  }

  static void showSettingsDialog() {
    Get.dialog(
      CommonDialog(
        title: 'Permission Required',
        contentWidget: const Text(
          'You have denied location permission forever. '
          'Please go to settings to enable it in order to '
          'proceed further operation.',
        ),
        positiveDialogBtnText: 'Go to settings',
        negativeRedDialogBtnText: 'Back',
        onPositiveButtonClicked: () {
          Get.back();
          Geolocator.openAppSettings();
        },
      ),
    );
  }
}
