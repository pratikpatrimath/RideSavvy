import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class RouteStep {
  String? travelMode;
  String? transitMode;
  String? vehicleMode;
  String? instructions;
  String? distance;
  double? distanceInKm;
  String? duration;
  LatLng? startLocation;
  LatLng? endLocation;
  String? polylinePoints;
  String? startTime;
  String? endTime;
  String? departureStopName;
  String? arrivalStopName;
  String? totalDuration;
  String? totalDistance;
  int? totalDurationValue;
  int? totalDistanceValue;

  RouteStep({
    this.travelMode,
    this.transitMode,
    this.vehicleMode,
    this.instructions,
    this.distance,
    this.distanceInKm,
    this.duration,
    this.startLocation,
    this.endLocation,
    this.polylinePoints,
    this.startTime,
    this.endTime,
    this.departureStopName,
    this.arrivalStopName,
    this.totalDuration,
    this.totalDurationValue,
    this.totalDistanceValue,
  });

  factory RouteStep.fromMap(Map<String, dynamic> map) {
    return RouteStep(
      travelMode: map['travel_mode'] as String?,
      transitMode: (map['transit_details'] != null &&
              map['transit_details']['line']['vehicle']['type'] != null)
          ? map['transit_details']['line']['vehicle']['type'] as String?
          : map['transit_mode'] as String?,
      vehicleMode: _extractVehicleName(map),
      instructions: map['html_instructions'] as String?,
      distance: _extractDistance(map),
      distanceInKm: _extractDistanceInKm(map),
      duration: _extractDuration(map),
      startLocation: LatLng(
        (map['start_location']['lat'] as num).toDouble(),
        (map['start_location']['lng'] as num).toDouble(),
      ),
      endLocation: LatLng(
        (map['end_location']['lat'] as num).toDouble(),
        (map['end_location']['lng'] as num).toDouble(),
      ),
      polylinePoints: map['polyline']['points'] as String?,
      startTime: getFormattedStartTime(map),
      endTime: getFormattedEndTime(map),
      departureStopName: _extractDepartureStopName(map),
      arrivalStopName: _extractArrivalStopName(map),
    );
  }

  static String? _extractVehicleName(Map<String, dynamic> map) {
    if (map['transit_details'] != null &&
        map['transit_details']['line'] != null) {
      if (map['transit_details']['line']['vehicle'] != null) {
        if (map['transit_details']['line']['vehicle']['name'] != null) {
          return map['transit_details']['line']['vehicle']['name'] as String?;
        } else if (map['transit_details']['line']['vehicle']['type'] != null) {
          return map['transit_details']['line']['vehicle']['type'] as String?;
        }
      }
    }
    return null;
  }

  static String _extractDistance(Map<String, dynamic> map) {
    if (map['distance'] != null) {
      return (map['distance']['text']).toString();
    }
    return "0 m";
  }

  static double _extractDistanceInKm(Map<String, dynamic> map) {
    if (map['distance'] != null) {
      final int distanceValue = map['distance']['value'] as int? ?? 0;
      return distanceValue / 1000;
    }
    return 0.0;
  }

  static String _extractDuration(Map<String, dynamic> map) {
    if (map['duration'] != null) {
      return (map['duration']['text']).toString();
    }
    return "0 min";
  }

  static String? getFormattedStartTime(Map<String, dynamic> map) {
    if (map['transit_details'] != null &&
        map['transit_details']['departure_time'] != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          map['transit_details']['departure_time']['value'] * 1000);
      return DateFormat('h:mm a').format(dateTime);
    }
    return null;
  }

  static String? getFormattedEndTime(Map<String, dynamic> map) {
    if (map['transit_details'] != null &&
        map['transit_details']['arrival_time'] != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          map['transit_details']['arrival_time']['value'] * 1000);
      return DateFormat('h:mm a').format(dateTime);
    }
    return null;
  }

  static String? _extractDepartureStopName(Map<String, dynamic> map) {
    if (map['transit_details'] != null &&
        map['transit_details']['departure_stop'] != null) {
      return map['transit_details']['departure_stop']['name'] as String?;
    }
    return null;
  }

  static String? _extractArrivalStopName(Map<String, dynamic> map) {
    if (map['transit_details'] != null &&
        map['transit_details']['arrival_stop'] != null) {
      return map['transit_details']['arrival_stop']['name'] as String?;
    }
    return null;
  }
}
