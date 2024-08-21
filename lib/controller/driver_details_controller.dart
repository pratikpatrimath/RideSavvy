import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';

import '../utility/constants/string_constants.dart';
import '../utility/helper/common_helper.dart';

class DriverDetailsController extends GetxController {
  RxString driverName = ''.obs;
  RxString vehicleName = ''.obs;
  RxString vehiclePlate = ''.obs;
  RxDouble rating = 2.0.obs;

  RxString vehicleNameArg = ''.obs;
  RxString serviceArg = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _loadArg();
    _generateRandomPlateNumber();
    _generateRandomDoubleBetweenTwoValues();
    _loadVehicleName();
    _loadDriverName();
  }

  void _loadArg() {
    vehicleNameArg.value = Get.arguments?[0] ?? 'Vehicle';
    serviceArg.value = Get.arguments?[1] ?? '';
  }

  Future<void> _loadDriverName() async {
    try {
      GetConnect getConnect = GetConnect();
      getConnect.timeout = const Duration(seconds: 30);
      Response response = await getConnect.get(StringConstants.nameGen);
      Map data = jsonDecode(response.body);
      driverName.value = data['name'] ?? "Sanjay Podar";
    } catch (e) {
      CommonHelper.printDebugError(e, "_loadDriverName()");
      driverName.value = "Sanjay Podar";
    }
  }

  Future<void> _loadVehicleName() async {
    try {
      String vehicleType = vehicleNameArg.value;
      Map<String, List<String>> vehicleList = StringConstants.vehicleNameList;

      if (vehicleList.containsKey(vehicleType)) {
        String? randomVehicleName;
        if (vehicleList[vehicleType] != null) {
          Random random = Random();
          int randomInt = random.nextInt(vehicleList[vehicleType]!.length);
          randomVehicleName = vehicleList[vehicleType]?[randomInt];
        }
        vehicleName.value = randomVehicleName ?? vehicleNameArg.value;
      } else {
        vehicleName.value = vehicleNameArg.value;
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "_loadDriverName()");
      vehicleName.value = vehicleNameArg.value;
    }
  }

  void _generateRandomPlateNumber() {
    try {
      String startLocation = 'MH02';
      String randomLetters = String.fromCharCodes(
        List.generate(2, (index) => Random().nextInt(26) + 65),
      );
      String randomDigits = Random().nextInt(10000).toString().padLeft(4, '0');
      String randomPlateNumber = '$randomLetters$randomDigits';
      vehiclePlate.value = "$startLocation$randomPlateNumber";
    } catch (e) {
      CommonHelper.printDebugError(e, "_generateRandomPlateNumber()");
      vehiclePlate.value = "Unknown";
    }
  }

  void _generateRandomDoubleBetweenTwoValues() {
    try {
      double min = 2.0;
      double max = 5.0;
      Random random = Random();
      double randomDouble = min + random.nextDouble() * (max - min);
      rating.value = randomDouble;
    } catch (e) {
      CommonHelper.printDebugError(e, "generateRandomDoubleBetweenTwoValues()");
      rating.value = 2.0;
    }
  }
}
