import '../../model/ride_comparison_result.dart';
import '../../model/vehicle.dart';
import '../constants/string_constants.dart';
import '../helper/common_helper.dart';
import 'vehicle_assigner.dart';

class RideEstimateCalculator {
  static const Map<String, Map<String, double>> farePrice = {
    StringConstants.olaService: {
      StringConstants.olaAuto: 25.0,
      StringConstants.olaMini: 40.0,
      StringConstants.olaPrimeSedan: 70.0,
      StringConstants.olaPrimeSUV: 100.0,
      StringConstants.olaLux: 120.0,
      StringConstants.olaKaaliPeeliTaxi: 30.0,
    },
    StringConstants.uberService: {
      StringConstants.uberAuto: 25.0,
      StringConstants.uberGo: 20.0,
      StringConstants.uberX: 30.0,
      StringConstants.uberXL: 50.0,
      StringConstants.uberBlack: 100.0,
      StringConstants.uberTaxi: 35.0,
    },
  };

  static const Map<String, Map<String, double>> perKmFareCharge = {
    StringConstants.olaService: {
      StringConstants.olaAuto: 7.0,
      StringConstants.olaMini: 3.0,
      StringConstants.olaPrimeSedan: 12.0,
      StringConstants.olaPrimeSUV: 18.0,
      StringConstants.olaLux: 22.0,
      StringConstants.olaKaaliPeeliTaxi: 8.0,
    },
    StringConstants.uberService: {
      StringConstants.uberAuto: 9.0,
      StringConstants.uberGo: 6.0,
      StringConstants.uberX: 8.0,
      StringConstants.uberXL: 14.0,
      StringConstants.uberBlack: 15.0,
      StringConstants.uberTaxi: 10.0,
    },
  };

  static const Map<String, Map<String, double>> perMinFareCharge = {
    StringConstants.olaService: {
      StringConstants.olaAuto: 1.5,
      StringConstants.olaMini: 2.0,
      StringConstants.olaPrimeSedan: 2.5,
      StringConstants.olaPrimeSUV: 4.0,
      StringConstants.olaLux: 5.0,
      StringConstants.olaKaaliPeeliTaxi: 1.8,
    },
    StringConstants.uberService: {
      StringConstants.uberAuto: 2.0,
      StringConstants.uberGo: 1.5,
      StringConstants.uberX: 2.0,
      StringConstants.uberXL: 2.5,
      StringConstants.uberBlack: 3.0,
      StringConstants.uberTaxi: 4.0,
    },
  };

  static double calculateEstimate({
    required String service,
    required String? name,
    required int distanceInM,
    required int totalTimeInSeconds,
  }) {
    if (name != null) {
      try {
        final baseFare = farePrice[service]![name]!;
        final perKmCharge = perKmFareCharge[service]![name]!;
        final perMinuteCharge = perMinFareCharge[service]![name]! / 60;

        final distanceInKM = distanceInM / 1000;
        final totalDistanceCharge = distanceInKM * perKmCharge;
        final totalDurationCharge = totalTimeInSeconds * perMinuteCharge;
        return baseFare + totalDistanceCharge + totalDurationCharge;
      } catch (e) {
        CommonHelper.printDebugError(e, "calculateEstimate()");
      }
    }
    return 0;
  }

  static List<Vehicle> calculateEstimatesForCategory({
    required String category,
    required int distanceInM,
    required int totalTimeInSeconds,
  }) {
    final vehicleList = VehicleAssigner.getCategoryVehicles(category);
    return vehicleList.map((name) {
      String service = name.toString().contains(StringConstants.uberService)
          ? StringConstants.uberService
          : StringConstants.olaService;
      return Vehicle(
        name: name,
        service: service,
        estimateFarePrice: calculateEstimate(
          service: service,
          name: name,
          distanceInM: distanceInM,
          totalTimeInSeconds: totalTimeInSeconds,
        ),
      );
    }).toList();
  }

  static Map<String, double> calculateEstimatesForService({
    required String service,
    required int distanceInM,
    required int totalTimeInSeconds,
  }) {
    final categoryVehicleMap = VehicleAssigner.getAllCategoryVehicles();
    final categoryEstimates = <String, double>{};
    for (var category in categoryVehicleMap.keys) {
      final vehicleList = categoryVehicleMap[category]!;
      final totalEstimate = vehicleList.map((name) {
        return calculateEstimate(
          service: service,
          name: name,
          distanceInM: distanceInM,
          totalTimeInSeconds: totalTimeInSeconds,
        );
      }).fold(0.0, (prev, estimate) => prev + estimate);
      categoryEstimates[category] = totalEstimate / vehicleList.length;
    }

    return categoryEstimates;
  }

  static List<RideComparisonResult> compareVehicles(List<Vehicle> vehicles) {
    List<Vehicle> olaVehicles = vehicles.where((v) {
      return v.service == StringConstants.olaService;
    }).toList();
    List<Vehicle> uberVehicles = vehicles.where((v) {
      return v.service == StringConstants.uberService;
    }).toList();

    olaVehicles.sort((a, b) => a.name!.compareTo(b.name!));
    uberVehicles.sort((a, b) => a.name!.compareTo(b.name!));

    List<RideComparisonResult> comparisonResults = [];

    _comparePair(
      olaVehicles,
      StringConstants.olaAuto,
      uberVehicles,
      StringConstants.uberAuto,
      comparisonResults,
    );
    _comparePair(
      olaVehicles,
      StringConstants.olaMini,
      uberVehicles,
      StringConstants.uberGo,
      comparisonResults,
    );
    _comparePair(
      olaVehicles,
      StringConstants.olaPrimeSedan,
      uberVehicles,
      StringConstants.uberX,
      comparisonResults,
    );
    _comparePair(
      olaVehicles,
      StringConstants.olaPrimeSUV,
      uberVehicles,
      StringConstants.uberXL,
      comparisonResults,
    );
    _comparePair(
      olaVehicles,
      StringConstants.olaLux,
      uberVehicles,
      StringConstants.uberBlack,
      comparisonResults,
    );
    _comparePair(
      olaVehicles,
      StringConstants.olaKaaliPeeliTaxi,
      uberVehicles,
      StringConstants.uberTaxi,
      comparisonResults,
    );

    return comparisonResults;
  }

  static void _comparePair(
    List<Vehicle> olaVehicles,
    String olaVehicleName,
    List<Vehicle> uberVehicles,
    String uberVehicleName,
    List<RideComparisonResult> comparisonResults,
  ) {
    Vehicle olaVehicle = olaVehicles.firstWhere(
      (v) => v.name == olaVehicleName,
      orElse: () => Vehicle(),
    );
    Vehicle uberVehicle = uberVehicles.firstWhere(
      (v) => v.name == uberVehicleName,
      orElse: () => Vehicle(),
    );

    double olaPrice = olaVehicle.estimateFarePrice ?? 0.0;
    double uberPrice = uberVehicle.estimateFarePrice ?? 0.0;

    RideComparisonResult result = RideComparisonResult(
      vehicleName: olaVehicle.name ?? "",
      olaVehicle: olaVehicle.name ?? "",
      uberVehicle: uberVehicle.name ?? "",
      olaPrice: olaPrice,
      uberPrice: uberPrice,
    );
    comparisonResults.add(result);
  }
}
