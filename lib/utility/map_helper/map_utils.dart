import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/common_helper.dart';
import 'map_icon.dart';

class MapUtils {
  static const double defaultCameraZoom = 20;

  static Future<void> openMap({
    required double latitude,
    required double longitude,
  }) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1'
        '&query=$latitude,$longitude';
    Uri googleUrlURI = Uri.parse(googleUrl);
    if (await canLaunchUrl(googleUrlURI)) {
      await launchUrl(
        googleUrlURI,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open the map.';
    }
  }

  static String latLngToString({required LatLng? latLng}) {
    LatLng latLngToConvert = latLng ?? const LatLng(0.0, 0.0);
    return "${latLngToConvert.latitude},${latLngToConvert.longitude}";
  }

  static LatLng? stringToLatLng({required String? latLngString}) {
    try {
      List<String>? latLngList = latLngString?.split(",");
      if (latLngString != null) {
        double latitude = double.tryParse(latLngList?.first ?? "") ?? 0.0;
        double longitude = double.tryParse(latLngList?.last ?? "") ?? 0.0;
        return LatLng(latitude, longitude);
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "MapUtils stringToLatLng()");
    }
    return null;
  }

  static void zoomInCamera({
    required GoogleMapController? controller,
    required LatLng? latLng,
    double? zoomLength,
  }) {
    try {
      if (latLng != null) {
        controller?.animateCamera(
          CameraUpdate.newLatLngZoom(
            latLng,
            zoomLength ?? defaultCameraZoom,
          ),
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "MapUtils zoomInCamera()");
    }
  }

  static Future<String?> getAddressFromLatLng({
    required LatLng? latLng,
  }) async {
    try {
      if (latLng != null) {
        List<Placemark> placeMarkList = await placemarkFromCoordinates(
          latLng.latitude,
          latLng.longitude,
        );
        Placemark place = placeMarkList[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}, '
            '${place.postalCode}, ${place.country}';
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "MapsUtils getAddressFromLatLng()");
    }
    return null;
  }

  static Future<Marker?> addMarker({
    required LatLng? latLng,
    required String? title,
    int? size,
    String? markerId,
    String? icon,
    String? snippet,
    bool? isFlat,
    Function()? onTapMarker,
    BitmapDescriptor? bitmapDescriptor,
  }) async {
    try {
      if (latLng != null) {
        bitmapDescriptor ??= await MapIcon.getBitmapDescriptor(
          icon: icon,
          size: size,
        );
        return Marker(
          markerId: MarkerId(markerId ?? latLng.toString()),
          position: latLng,
          anchor: const Offset(0.5, 0.5),
          icon: bitmapDescriptor,
          flat: isFlat ?? false,
          infoWindow: title != null
              ? InfoWindow(
                  title: title,
                  snippet: snippet,
                  onTap: () {
                    try {
                      if (onTapMarker != null) {
                        onTapMarker();
                      } else {
                        MapUtils.openMap(
                          latitude: latLng.latitude,
                          longitude: latLng.longitude,
                        );
                      }
                    } catch (e) {
                      CommonHelper.printDebugError(e, "MapUtils onTapMarker()");
                    }
                  },
                )
              : const InfoWindow(),
        );
      } else {
        CommonHelper.printDebugError("LatLng empty", "MapUtils addMarker()");
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "MapUtils addMarker()");
    }
    return null;
  }
}
