import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/driver_details_controller.dart';
import '../utility/constants/dimens_constants.dart';

class DriverDetailsScreen extends StatelessWidget {
  DriverDetailsScreen({super.key});

  // final DriverDetailsController _controller =
  //     Get.put(DriverDetailsController());
  final DriverDetailsController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Obx(() => _body()),
    );
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _controller.vehiclePlate.value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.textTheme.titleLarge?.fontSize,
            ),
          ),
          Text(_controller.vehicleName.value),
          Row(
            children: [
              Text(_controller.driverName.value),
              const SizedBox(width: DimenConstants.contentPadding),
              const Icon(Icons.star, color: Colors.amber),
              Text(_controller.rating.toStringAsFixed(2)),
            ],
          )
        ],
      ),
    );
  }
}
