import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/route_step.dart';
import '../constants/string_constants.dart';
import '../helper/common_helper.dart';

class PolyLineUtils {
  static Future<List<RouteStep>> getRouteDetails({
    required LatLng? origin,
    required LatLng? destination,
    String? travelMode,
    List<String>? selectedTransitModes,
  }) async {
    List<RouteStep> routeSteps = [];
    try {
      String apiKey = StringConstants.googleMapKey;
      String mode = travelMode?.toLowerCase() ?? 'driving';
      String url;

      if (travelMode != null && travelMode.toLowerCase() == "transit") {
        url = "https://maps.googleapis.com/maps/api/directions/json?origin="
            "${origin?.latitude},${origin?.longitude}"
            "&destination=${destination?.latitude},${destination?.longitude}"
            "&mode=transit"
            "&transit_mode=${_getTransitModes(selectedTransitModes)}"
            "&key=$apiKey";
      } else {
        url = "https://maps.googleapis.com/maps/api/directions/json?origin="
            "${origin?.latitude},${origin?.longitude}"
            "&destination=${destination?.latitude},${destination?.longitude}"
            "&mode=$mode&key=$apiKey";
      }

      CommonHelper.printDebugError(url, "");
      Response response = await GetConnect().get(url);
      Map values = response.body;

      if (response.isOk) {
        var legs = values["routes"]?[0]?["legs"];
        var steps = legs?[0]?["steps"];
        String? totalDuration = legs?[0]?["duration"]?["text"] ?? "Unknown min";
        String? totalDistance = legs?[0]?["distance"]?["text"] ?? "Unknown m";
        int totalDurationValue = legs?[0]?["duration"]?["value"] ?? 0;
        int totalDistanceValue = legs?[0]?["distance"]?["value"] ?? 0;

        for (var step in steps) {
          RouteStep routeStep = RouteStep.fromMap(step);
          routeStep.totalDistance = totalDistance;
          routeStep.totalDuration = totalDuration;
          routeStep.totalDurationValue = totalDurationValue;
          routeStep.totalDistanceValue = totalDistanceValue;
          routeSteps.add(routeStep);
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "PolyLineUtils getRouteDetails()");
    }
    return routeSteps;
  }

  static String _getTransitModes(List<String>? transitModeList) {
    String selectedTransits = '';

    if (transitModeList != null) {
      for (String transitMode in transitModeList) {
        switch (transitMode) {
          case "Bus":
            selectedTransits += 'bus|';
            break;
          case "Subway":
            selectedTransits += 'subway|';
            break;
          case "Train":
            selectedTransits += 'train|';
            break;
          case "Tram and light rail":
            selectedTransits += 'tram|';
            break;
        }
      }
      selectedTransits = selectedTransits.replaceAll(RegExp(r'\|*$'), '');
    }

    return selectedTransits.trim().isNotEmpty ? selectedTransits : 'bus';
  }

  static Future<List<Polyline>> addPolyLines({
    required LatLng? origin,
    required List<RouteStep> routeSteps,
  }) async {
    List<Polyline> polylineList = [];

    for (int i = 0; i < routeSteps.length; i++) {
      RouteStep step = routeSteps[i];
      if (step.polylinePoints != null) {
        List<LatLng> decodedPoints = decodePoly(poly: step.polylinePoints!);
        Color polylineColor = _getPolylineColor(
          travelMode: step.travelMode,
          transitMode: step.transitMode,
          vehicleMode: step.vehicleMode,
        );

        List<PatternItem> polylinePatterns = _getPolylinePatterns(
          travelMode: step.travelMode,
          transitMode: step.transitMode,
          vehicleMode: step.vehicleMode,
        );

        Polyline polyline = Polyline(
          polylineId: PolylineId(
            step.startLocation.toString() + step.endLocation.toString(),
          ),
          visible: true,
          points: decodedPoints,
          color: polylineColor,
          width: 5,
          patterns: polylinePatterns,
        );
        polylineList.add(polyline);
      }
    }

    return polylineList.isNotEmpty ? polylineList : [];
  }

  static Color _getPolylineColor({
    String? travelMode,
    String? transitMode,
    String? vehicleMode,
  }) {
    if (transitMode != null) {
      switch (transitMode.toLowerCase()) {
        case 'bus':
          return const Color.fromARGB(255, 0, 0, 255);
        case 'subway':
          return const Color.fromARGB(255, 255, 0, 0);
        case 'train':
          return Colors.yellow;
        case 'tram':
          return const Color.fromARGB(255, 255, 165, 0);
        default:
          return Colors.blue; // Default color
      }
    } else if (vehicleMode != null) {
      switch (vehicleMode.toLowerCase()) {
        case 'car':
          return const Color.fromARGB(255, 0, 0, 255);
        case 'bike':
          return const Color.fromARGB(255, 0, 0, 255);
        case 'cycling':
          return Colors.black;
        case 'motorcycle':
          return const Color.fromARGB(255, 255, 165, 0);
        default:
          return Colors.blue;
      }
    } else if (travelMode != null) {
      switch (travelMode.toLowerCase()) {
        case 'driving':
          return const Color.fromARGB(255, 0, 0, 255);
        case 'transit':
          return const Color.fromARGB(255, 0, 128, 0);
        default:
          return Colors.blue;
      }
    } else {
      return Colors.blue;
    }
  }

  static List<PatternItem> _getPolylinePatterns({
    String? travelMode,
    String? transitMode,
    String? vehicleMode,
  }) {
    if (travelMode != null) {
      switch (travelMode.toLowerCase()) {
        case 'walking':
          return [PatternItem.dash(5), PatternItem.dot, PatternItem.gap(5)];
        default:
          return [];
      }
    }
    return [];
  }

  static List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  static List<LatLng> decodePoly({required String poly}) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }

      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    return convertToLatLng(lList);
  }

  static double distanceFormula(lat1, lon1, lat2, lon2) {
    try {
      var p = 0.017453292519943295;
      var a = 0.5 -
          cos((lat2 - lat1) * p) / 2 +
          cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    } catch (e) {
      return 0.0;
    }
  }

  static double calculateDistance({
    required List<LatLng> polylineCoordinates,
  }) {
    double totalDistance = 0.0;
    try {
      for (var i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += distanceFormula(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "PolyLineUtils calculateDistance()");
    }
    return totalDistance;
  }
}
