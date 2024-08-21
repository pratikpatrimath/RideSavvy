import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/route_step.dart';
import '../model/vehicle.dart';
import '../utility/common_widgets/common_dialog.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/string_constants.dart';
import '../utility/data/ride_estimate_calculator.dart';
import '../utility/data/vehicle_assigner.dart';
import '../utility/helper/common_helper.dart';
import '../utility/map_helper/gps_utils.dart';
import '../utility/map_helper/map_utils.dart';
import '../utility/map_helper/poly_line_utils.dart';
import '../utility/map_helper/search_view.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/user_pref.dart';

class HomeController extends GetxController {
  RxBool isSelectLocationVisible = true.obs;
  RxBool isBottomSheetVisible = false.obs;
  RxString selectedCategory = ''.obs;

  RxDouble estOlaPrice = 0.0.obs;
  RxDouble estUberPrice = 0.0.obs;

  RxBool isLoading = false.obs;
  RxBool isMapLoading = true.obs;
  Rxn<LatLng> startLatLng = Rxn();
  Rxn<LatLng> destinationLatLng = Rxn();

  RxList<Marker> markerList = <Marker>[].obs;
  RxList<RouteStep> routeStepList = <RouteStep>[].obs;
  RxList<Polyline> polylineList = <Polyline>[].obs;

  GoogleMapController? googleMapController;
  LatLng emptyLocation = const LatLng(0.0, 0.0);
  final Completer<GoogleMapController> _controller = Completer();

  late TextEditingController etStartLocation;
  late TextEditingController etDestinationLocation;

  RxList<Vehicle> nearbyVehicleList = <Vehicle>[].obs;
  RxList<Vehicle> olaVehicles = <Vehicle>[].obs;
  RxList<Vehicle> uberVehicles = <Vehicle>[].obs;
  Rxn<Map<String, double>> olaAveragePricing = Rxn();
  Rxn<Map<String, double>> uberAveragePricing = Rxn();
  Rxn<Map<String, double>> allOlaAveragePricing = Rxn();
  Rxn<Map<String, double>> allUberAveragePricing = Rxn();

  @override
  void onInit() {
    super.onInit();
    isMapLoading.value = true;
    GpsUtils.requestLocation().then((value) => _fetchUserLocation());
    initUI();
    initListeners();
  }

  Future<void> onMapCreated(GoogleMapController googleMapController) async {
    try {
      _controller.complete(googleMapController);
      this.googleMapController = googleMapController;
      await _fetchUserLocation();
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController onMapCreated()");
    } finally {
      isMapLoading.value = false;
    }
  }

  void initUI() {
    etStartLocation = TextEditingController();
    etDestinationLocation = TextEditingController();
  }

  void initListeners() {
    startLatLng.listen((p0) => _placeMarkers());
    destinationLatLng.listen((p0) => _placeMarkers());
    selectedCategory.listen((selectedCategoryValue) {
      if (olaAveragePricing.value != null) {
        olaAveragePricing.value = Map.fromEntries(allOlaAveragePricing
            .value!.entries
            .where((entry) => entry.key == selectedCategoryValue));
      }

      if (uberAveragePricing.value != null) {
        uberAveragePricing.value = Map.fromEntries(allUberAveragePricing
            .value!.entries
            .where((entry) => entry.key == selectedCategoryValue));
      }
    });
  }

  void closeBottomSheet() {
    while (Get.isBottomSheetOpen == true) {
      Get.back();
    }
    isBottomSheetVisible.value = false;
  }

  void onTapPopupMenu(String value) {
    if (value == "Logout") {
      _onTapLogout();
    } else if (value == "Exit") {
      _onTapExit();
    } else {
      Get.toNamed(RouteConstants.profileScreen);
    }
  }

  void onTapDirectionIcon() {
    isSelectLocationVisible.value = !isSelectLocationVisible.value;
    isBottomSheetVisible.value = !isBottomSheetVisible.value;
  }

  void gpay() {}
  void onClickBtnComparison() {
    Get.toNamed(
      RouteConstants.viewAllVehiclePricesScreen,
      arguments: nearbyVehicleList.value,
    );
  }

  void onTapSearch({bool? isDestination}) {
    try {
      if (googleMapController != null) {
        showSearch(
          context: Get.context as BuildContext,
          delegate: SearchView(),
        ).then((value) {
          onSearched(value: value, isDestination: isDestination);
        });
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController onTapSearch()");
    } finally {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _onTapLogout() {
    Get.dialog(
      CommonDialog(
        title: "Logout",
        contentWidget: const Text("Are you sure you want to logout?"),
        negativeRedDialogBtnText: "Confirm",
        positiveDialogBtnText: "Back",
        onNegativeRedBtnClicked: () {
          Get.back();
          logout();
        },
      ),
    );
  }

  void _onTapExit() {
    Get.dialog(CommonDialog(
      title: "Exit",
      contentWidget: const Text("Are you sure you want to exit?"),
      negativeRedDialogBtnText: "Confirm",
      positiveDialogBtnText: "Back",
      onNegativeRedBtnClicked: () {
        Get.back();
        exit(0);
      },
    ));
  }

  Future<void> logout() async {
    try {
      await UserPref.removeAllFromUserPref();
      Get.offAllNamed(RouteConstants.loginScreen);
    } catch (e) {
      CommonHelper.printDebugError(e, "logout()");
    }
  }

  Future<void> _fetchUserLocation() async {
    try {
      if (startLatLng.value == null) {
        Position? position = await GpsUtils.getCurrentLocation();
        if (position != null) {
          startLatLng.value = LatLng(position.latitude, position.longitude);
          if (startLatLng.value != emptyLocation) {
            String? address = await MapUtils.getAddressFromLatLng(
              latLng: startLatLng.value,
            );
            etStartLocation.text = address ?? "";
          }
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController()");
    }
  }

  void onSearched({required String value, bool? isDestination}) async {
    try {
      List<Location> locationList = await locationFromAddress(value);
      Location location = locationList.first;
      LatLng latLng = LatLng(location.latitude, location.longitude);
      if (isDestination == true) {
        etDestinationLocation.text = value;
        destinationLatLng.value = latLng;
      } else {
        etStartLocation.text = value;
        startLatLng.value = latLng;
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController onSearched()");
    } finally {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _placeMarkers() {
    CommonProgressBar.show();
    markerList.clear();
    polylineList.clear();
    if (googleMapController != null) {
      _addMarker(startLatLng.value, "Starting Point");
      _addMarker(destinationLatLng.value, "Destination");
      _zoomCameraAndAddPolyLine();
    }
    CommonProgressBar.hide();
  }

  Future<void> _addMarker(LatLng? latLng, String title) async {
    if (latLng != emptyLocation) {
      Marker? marker = await MapUtils.addMarker(latLng: latLng, title: title);
      marker != null ? markerList.add(marker) : null;
    }
  }

  void cameraZoomIn(LatLng? latLng, double? zoomLength) {
    MapUtils.zoomInCamera(
      controller: googleMapController!,
      latLng: latLng,
      zoomLength: zoomLength,
    );
  }

  Future<void> _zoomCameraAndAddPolyLine() async {
    if (startLatLng.value != emptyLocation) {
      cameraZoomIn(startLatLng.value, null);
      if (destinationLatLng.value != emptyLocation) {
        routeStepList.value = await PolyLineUtils.getRouteDetails(
          origin: startLatLng.value,
          destination: destinationLatLng.value,
        );

        if (routeStepList.isNotEmpty) {
          List<Polyline>? list = await PolyLineUtils.addPolyLines(
            origin: startLatLng.value!,
            routeSteps: routeStepList,
          );

          if (list.isNotEmpty) {
            polylineList.addAll(list);
            cameraZoomIn(startLatLng.value, 12.0);
          }
        }
      }
    }

    nearbyVehicleList.value = VehicleAssigner.getNearByVehicles(
      startLatitude: startLatLng.value?.latitude,
      startLongitude: startLatLng.value?.longitude,
      totalTimeInSeconds: routeStepList.firstOrNull?.totalDurationValue ?? 1,
      distanceInM: routeStepList.firstOrNull?.totalDistanceValue ?? 1,
    );
    for (Vehicle vehicle in nearbyVehicleList) {
      if (vehicle.latitude != null && vehicle.longitude != null) {
        Marker? marker = await MapUtils.addMarker(
          icon: StringConstants.carMapIcon,
          size: 64,
          latLng: LatLng(vehicle.latitude!, vehicle.longitude!),
          title: null,
          isFlat: true,
          onTapMarker: () => {},
        );
        marker != null ? markerList.add(marker) : null;
      }
    }
    if (nearbyVehicleList.isNotEmpty) {
      var olaPricing = RideEstimateCalculator.calculateEstimatesForService(
        service: StringConstants.olaService,
        totalTimeInSeconds: routeStepList.firstOrNull?.totalDurationValue ?? 1,
        distanceInM: routeStepList.firstOrNull?.totalDistanceValue ?? 1,
      );
      var uberPricing = RideEstimateCalculator.calculateEstimatesForService(
        service: StringConstants.uberService,
        totalTimeInSeconds: routeStepList.firstOrNull?.totalDurationValue ?? 1,
        distanceInM: routeStepList.firstOrNull?.totalDistanceValue ?? 1,
      );

      allOlaAveragePricing.value = olaPricing;
      allUberAveragePricing.value = uberPricing;
      if (selectedCategory.value.trim().isNotEmpty) {
        olaAveragePricing.value = Map.fromEntries(olaPricing.entries
            .where((entry) => entry.key == selectedCategory.value));
        uberAveragePricing.value = Map.fromEntries(uberPricing.entries
            .where((entry) => entry.key == selectedCategory.value));
      } else {
        olaAveragePricing.value = olaPricing;
        uberAveragePricing.value = uberPricing;
      }
    }
  }
}
