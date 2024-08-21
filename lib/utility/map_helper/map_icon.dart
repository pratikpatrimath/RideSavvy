import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/string_constants.dart';
import '../helper/common_helper.dart';

class MapIcon {
  static BitmapDescriptor? carMapIcon, nightClubIcon, shoppingMallIcon;
  static BitmapDescriptor? beachIcon, hospitalIcon, policeIcon;

  static Future<BitmapDescriptor> getBitmapDescriptor({
    required String? icon,
    int? size,
  }) async {
    BitmapDescriptor? bitmapDescriptor;
    if (icon == null) return BitmapDescriptor.defaultMarker;
    if (carMapIcon == null) await setCarIcon();
    bitmapDescriptor = carMapIcon;
    if (size != null) {
      bitmapDescriptor = await getResizedIcon(carMapIcon, size);
    } else {
      bitmapDescriptor = carMapIcon;
    }

    return bitmapDescriptor ?? BitmapDescriptor.defaultMarker;
  }

  static Future<BitmapDescriptor> getResizedIcon(
    BitmapDescriptor? originalIcon,
    int size,
  ) async {
    if (originalIcon == null) return BitmapDescriptor.defaultMarker;

    final Uint8List? resizedIcon = await CommonHelper.getBytesFromAsset(
      path: StringConstants.carIcon,
      size: size,
    );

    if (resizedIcon != null) {
      return BitmapDescriptor.fromBytes(resizedIcon);
    } else {
      return BitmapDescriptor.defaultMarker;
    }
  }

  static Future<void> setCarIcon() async {
    try {
      final Uint8List? markerIcon = await CommonHelper.getBytesFromAsset(
        path: StringConstants.carIcon,
      );
      if (markerIcon != null) {
        carMapIcon = BitmapDescriptor.fromBytes(markerIcon);
      } else {
        BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(2, 2), devicePixelRatio: 3.0),
          StringConstants.carMapIcon,
        ).then((onValue) {
          carMapIcon = onValue;
        });
      }
    } catch (e) {
      carMapIcon = BitmapDescriptor.defaultMarker;
    }
  }
}
