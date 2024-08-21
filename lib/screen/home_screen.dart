import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ola_uber_price_comparison/screen/payment_page.dart';

import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/home_controller.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/common_widgets/custom_text_field.dart';
import '../utility/constants/string_constants.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });

    return CommonScaffold(
      key: const Key("HomeScreen"),
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        actions: [_actionWidget()],
      ),
      body: Obx(
        () => Stack(
          children: [
            _googleMap(),
            Visibility(
              visible: _controller.isSelectLocationVisible.value,
              child: SingleChildScrollView(child: _textFields()),
            ),
            _controller.isMapLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DimenConstants.contentPadding,
          ),
          child: InkWell(
            onTap: () => Get.to(() => const PaymentPage()),
            child: const Icon(Icons.payment_sharp),
          ),
        ),
        _popupMenu(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DimenConstants.contentPadding,
          ),
          child: InkWell(
            onTap: () => _controller.onTapDirectionIcon(),
            child: const Icon(Icons.directions_outlined),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DimenConstants.contentPadding,
          ),
          child: InkWell(
            onTap: () => _showBottomSheet(),
            child: const Icon(Icons.price_change_outlined),
          ),
        ),
      ],
    );
  }

  Widget _popupMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DimenConstants.contentPadding,
      ),
      child: PopupMenuButton<String>(
        elevation: DimenConstants.cardElevation,
        onSelected: (value) => _controller.onTapPopupMenu(value),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'Profile', child: Text('Profile')),
          const PopupMenuItem<String>(value: 'Logout', child: Text('Logout')),
          const PopupMenuItem<String>(value: 'Exit', child: Text('Exit')),
        ],
        child: const Icon(Icons.manage_accounts_outlined),
      ),
    );
  }

  Widget _googleMap() {
    return GoogleMap(
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      mapToolbarEnabled: true,
      trafficEnabled: true,
      compassEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(_controller.markerList),
      polylines: Set<Polyline>.of(_controller.polylineList),
      initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
      onMapCreated: (GoogleMapController googleMapController) {
        _controller.onMapCreated(googleMapController);
      },
    );
  }

  Widget _textFields() {
    return Card(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            hintText: "Start Location",
            prefixIcon: Icons.location_searching_outlined,
            textEditingController: _controller.etStartLocation,
            onTapField: () => _controller.onTapSearch(),
          ),
          CustomTextField(
            hintText: "Destination",
            prefixIcon: Icons.edit_location_alt_outlined,
            textEditingController: _controller.etDestinationLocation,
            onTapField: () => _controller.onTapSearch(isDestination: true),
          ),
          Padding(
            padding: const EdgeInsets.all(DimenConstants.contentPadding),
            child: Text(
              '* Click on direction icon on top right to hide/show this window',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: Get.textTheme.bodyMedium?.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    if (!_controller.isBottomSheetVisible.value) {
      _controller.isBottomSheetVisible.value = true;
      showModalBottomSheet(
        enableDrag: true,
        elevation: DimenConstants.cardElevation,
        backgroundColor: Colors.white,
        context: Get.context as BuildContext,
        builder: (BuildContext buildContext) {
          return Obx(() => _bottomSheetBody());
        },
      ).then((value) => _controller.closeBottomSheet());
    } else {
      _controller.closeBottomSheet();
    }
  }

  Widget _bottomSheetBody() {
    return GestureDetector(
      onTap: () => _controller.closeBottomSheet(),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DimenConstants.layoutPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _vehicleTypeCard(
                    icon: StringConstants.autoIcon,
                    text: StringConstants.auto,
                  ),
                  _vehicleTypeCard(
                    icon: StringConstants.carIcon,
                    text: StringConstants.car,
                  ),
                  _vehicleTypeCard(
                    icon: StringConstants.taxiIcon,
                    text: StringConstants.taxi,
                  ),
                ],
              ),
              _olaAveragePricing(),
              _uberAveragePricing(),
              CustomButton(
                buttonText: 'View Detail Price Comparison',
                onButtonPressed: () => _controller.onClickBtnComparison(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _olaAveragePricing() {
    Map<String, double>? olaPricing = _controller.olaAveragePricing.value;
    if (olaPricing == null || olaPricing.isEmpty) {
      return Card(
        child: Container(
          constraints: BoxConstraints(minWidth: Get.width),
          padding: const EdgeInsets.all(DimenConstants.mainCardRadius),
          child: const Center(child: Text('No pricing data available')),
        ),
      );
    }

    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: olaPricing.length,
      itemBuilder: (context, index) {
        String serviceName = olaPricing.keys.elementAt(index);
        double price = olaPricing[serviceName]!;
        return _comparisonText(
          icon: StringConstants.olaIcon,
          text: 'Estimate Ola $serviceName Price : ${price.toStringAsFixed(2)}',
        );
      },
    );
  }

  Widget _uberAveragePricing() {
    Map<String, double>? uberPricing = _controller.uberAveragePricing.value;
    if (uberPricing == null || uberPricing.isEmpty) {
      return Card(
        child: Container(
          constraints: BoxConstraints(minWidth: Get.width),
          padding: const EdgeInsets.all(DimenConstants.mainCardRadius),
          child: const Center(child: Text('No pricing data available')),
        ),
      );
    }

    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: uberPricing.length,
      itemBuilder: (context, index) {
        String serviceName = uberPricing.keys.elementAt(index);
        double price = uberPricing[serviceName]!;

        return _comparisonText(
          icon: StringConstants.uberIcon,
          text: 'Estimate Uber $serviceName '
              'Price : ${price.toStringAsFixed(2)}',
        );
      },
    );
  }

  Widget _vehicleTypeCard({
    required String icon,
    required String text,
  }) {
    return Obx(
      () {
        return Expanded(
          child: Card(
            child: Container(
              color: _controller.selectedCategory.value == text
                  ? Get.theme.colorScheme.primary
                  : null,
              constraints: BoxConstraints(minWidth: Get.size.width),
              child: InkWell(
                onTap: () => _controller.selectedCategory.value = text,
                child: Padding(
                  padding: const EdgeInsets.all(DimenConstants.contentPadding),
                  child: Image.asset(
                    icon,
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error_rounded,
                        color: _controller.selectedCategory.value == text
                            ? Get.theme.colorScheme.onPrimary
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _comparisonText({required String icon, required String text}) {
    return Card(
      child: Container(
        constraints: BoxConstraints(minWidth: Get.size.width),
        padding: const EdgeInsets.all(DimenConstants.contentPadding),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(DimenConstants.contentPadding),
              child: Image.asset(
                icon,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return Container();
                },
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
              style: TextStyle(
                fontSize: Get.textTheme.titleMedium?.fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
