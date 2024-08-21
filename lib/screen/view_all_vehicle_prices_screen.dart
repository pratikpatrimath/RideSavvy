import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_data_holder.dart';
import '../controller/view_all_vehicle_prices_controller.dart';
import '../model/ride_comparison_result.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/constants/string_constants.dart';

class ViewAllVehiclePricesScreen extends StatelessWidget {
  ViewAllVehiclePricesScreen({super.key});

  final ViewAllVehiclePricesController _controller =
      Get.put(ViewAllVehiclePricesController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Vehicle Prices"),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: CommonDataHolder(
              controller: _controller,
              dataList: _controller.rideCompareList,
              widget: _dataHolderWidget(),
              noResultText: "No Comparison found",
            ),
          );
        },
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _bottomBar() {
    return Row(
      children: [
        Expanded(child: _bottomButtonText(isUberService: false)),
        Expanded(child: _bottomButtonText(isUberService: true)),
      ],
    );
  }

  Widget _dataHolderWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: Get.height / 1.2),
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Column(
        children: [
          _header(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: _controller.rideCompareList.length,
            itemBuilder: (context, index) {
              return _buildComparisonCard(_controller.rideCompareList[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: DimenConstants.mixPadding,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _title(title: "Type", flex: 2),
            _title(title: "Ola", flex: 3),
            _title(title: "Uber", flex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(RideComparisonResult result) {
    return InkWell(
      onTap: () {
        _controller.closeDialog();
        Get.dialog(_optionDialog(result: result));
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: DimenConstants.mixPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: _vehicleTypeIcon(category: result.vehicleName),
              ),
              Expanded(
                flex: 3,
                child: _priceWidget(
                  price: result.olaPrice,
                  vehicleName: result.olaVehicle,
                ),
              ),
              Expanded(
                flex: 3,
                child: _priceWidget(
                  price: result.uberPrice,
                  vehicleName: result.uberVehicle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleTypeIcon({required String category}) {
    String? icon;
    switch (category) {
      case StringConstants.auto:
        icon = StringConstants.autoIcon;
        break;
      case StringConstants.olaMini:
        icon = StringConstants.miniCarIcon;
        break;
      case StringConstants.olaPrimeSedan:
        icon = StringConstants.carIcon;
        break;
      case StringConstants.olaPrimeSUV:
        icon = StringConstants.suvIcon;
        break;
      case StringConstants.olaLux:
        icon = StringConstants.luxuryCarIcon;
        break;
      case StringConstants.olaKaaliPeeliTaxi:
        icon = StringConstants.taxiIcon;
        break;
    }
    return Center(
      child: Image.asset(
        icon ?? '',
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.directions_car);
        },
      ),
    );
  }

  Widget _title({required String title, required int flex}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Get.textTheme.titleMedium?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _priceWidget({required double? price, required String? vehicleName}) {
    return Center(
      child: Column(
        children: [
          Text(
            price?.toStringAsFixed(2) ?? "--",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(vehicleName ?? ""),
        ],
      ),
    );
  }

  Widget _optionDialog({required RideComparisonResult result}) {
    return SimpleDialog(
      children: [
        SimpleDialogOption(
          onPressed: () => _controller.onTapVehicleCard(
            vehicleName: result.olaVehicle,
            service: StringConstants.olaService,
          ),
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: _comparisonText(icon: StringConstants.olaIcon, text: 'Ola'),
        ),
        const Divider(),
        SimpleDialogOption(
          onPressed: () => _controller.onTapVehicleCard(
            vehicleName: result.uberVehicle,
            service: StringConstants.uberService,
          ),
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: _comparisonText(icon: StringConstants.uberIcon, text: 'Uber'),
        ),
      ],
    );
  }

  Widget _comparisonText({required String icon, required String text}) {
    return Container(
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
            style: TextStyle(
              fontSize: Get.textTheme.titleMedium?.fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButtonText({required bool isUberService}) {
    return InkWell(
      onTap: () => _controller.onTapRedirectButton(
        isUberService: isUberService,
      ),
      child: Card(
        child: Container(
          constraints: BoxConstraints(minWidth: Get.size.width),
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(DimenConstants.contentPadding),
                child: Image.asset(
                  isUberService
                      ? StringConstants.uberIcon
                      : StringConstants.olaIcon,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
              ),
              Text(
                "Redirect to \n${isUberService ? 'Uber' : 'Ola'}",
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Get.textTheme.titleMedium?.fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
