import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ola_uber_price_comparison/controller/driver_details_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/ride_comparison_result.dart';
import '../model/vehicle.dart';
import '../screen/driver_details_screen.dart';
import '../utility/data/ride_estimate_calculator.dart';
import '../utility/helper/snack_bar_utils.dart';

class ViewAllVehiclePricesController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Vehicle> vehicleList = <Vehicle>[].obs;
  RxList<RideComparisonResult> rideCompareList = <RideComparisonResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    vehicleList.value = Get.arguments ?? [];
    rideCompareList.value = RideEstimateCalculator.compareVehicles(vehicleList);
  }

  Future<void> onTapRedirectButton({required bool isUberService}) async {
    String olaUrl = "https://www.olacabs.com/";
    String uberUrl = "https://www.uber.com/in/en/?uclick_id="
        "41dbf608-b300-44e1-bb96-0082a4765f8c";
    String url = isUberService ? uberUrl : olaUrl;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.platformDefault).then(
        (value) {
          if (value != true) {
            SnackBarUtils.errorSnackBar(
              title: 'Failed',
              message: 'Something Went Wrong!!!',
            );
          }
        },
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: 'Failed',
        message: 'Something Went Wrong!!!',
      );
    }
  }

  void onTapVehicleCard({
    required String vehicleName,
    required String service,
  }) {
    closeDialog();
    Get.dialog(
      barrierDismissible: true,
      useSafeArea: true,
      GetBuilder<DriverDetailsController>(
        init: DriverDetailsController(),
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: InkWell(
              onTap: () => closeDialog(),
              child: Center(child: DriverDetailsScreen()),
            ),
          );
        },
      ),
      arguments: [vehicleName, service],
    );
  }

  void closeDialog() {
    while (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}
