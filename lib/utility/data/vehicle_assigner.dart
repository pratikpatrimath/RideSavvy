import 'dart:math';

import '../../model/vehicle.dart';
import '../constants/string_constants.dart';
import 'ride_estimate_calculator.dart';

class VehicleAssigner {
  static List<Vehicle> getNearByVehicles({
    required double? startLatitude,
    required double? startLongitude,
    required int distanceInM,
    required int totalTimeInSeconds,
  }) {
    List<Vehicle> vehicles = [];
    if (startLatitude != null && startLongitude != null) {
      double centerLat = startLatitude;
      double centerLng = startLongitude;

      for (String category in StringConstants.categoryList) {
        List<String> categoryVehicles = getCategoryVehicles(category);
        for (int i = 0; i < categoryVehicles.length; i++) {
          double randomLat = _generateRandomCoordinate(centerLat);
          double randomLng = _generateRandomCoordinate(centerLng);
          String vehicleName = categoryVehicles[i];

          String service =
              vehicleName.toString().contains(StringConstants.uberService)
                  ? StringConstants.uberService
                  : StringConstants.olaService;

          double estimate = RideEstimateCalculator.calculateEstimate(
            service: service,
            name: vehicleName,
            distanceInM: distanceInM,
            totalTimeInSeconds: totalTimeInSeconds,
          );

          vehicles.add(
            Vehicle(
              service: service,
              category: category,
              name: categoryVehicles[i],
              latitude: randomLat,
              longitude: randomLng,
              estimateFarePrice: estimate,
            ),
          );
        }
      }
    }

    return vehicles;
  }

  static List<String> getCategoryVehicles(String category) {
    switch (category) {
      case StringConstants.auto:
        return [
          StringConstants.olaAuto,
          StringConstants.uberAuto,
        ];
      case StringConstants.car:
        return [
          StringConstants.olaMini,
          StringConstants.olaPrimeSedan,
          StringConstants.olaPrimeSUV,
          StringConstants.olaLux,
          StringConstants.uberGo,
          StringConstants.uberX,
          StringConstants.uberXL,
          StringConstants.uberBlack,
        ];
      case StringConstants.taxi:
        return [StringConstants.olaKaaliPeeliTaxi, StringConstants.uberTaxi];
      default:
        return [];
    }
  }

  static Map<String, List<String>> getAllCategoryVehicles() {
    return {
      StringConstants.auto: [
        StringConstants.olaAuto,
        StringConstants.uberAuto,
      ],
      StringConstants.taxi: [
        StringConstants.olaKaaliPeeliTaxi,
        StringConstants.uberTaxi,
      ],
      StringConstants.car: [
        StringConstants.olaMini,
        StringConstants.olaPrimeSedan,
        StringConstants.olaPrimeSUV,
        StringConstants.olaLux,
        StringConstants.uberGo,
        StringConstants.uberX,
        StringConstants.uberXL,
        StringConstants.uberBlack,
      ],
    };
  }

  static double _generateRandomCoordinate(double centerCoordinate) {
    Random random = Random();
    double offset = (random.nextDouble() - 0.5) * 0.01;
    return centerCoordinate + offset;
  }
}
