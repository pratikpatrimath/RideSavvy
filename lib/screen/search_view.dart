import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controller/search_view_controller.dart';
import '../utility/constants/string_constants.dart';

class SearchView extends SearchDelegate {
  final SearchViewController _controller = Get.put(SearchViewController());

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("Search term must be of at least one letter letters."),
          )
        ],
      );
    } else {
      _controller.getSuggestion(query);
      return Obx(
        () {
          if (_controller.isLoading.value == true) {
            return Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: Lottie.asset(
                  StringConstants.loadingLottie,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            );
          } else {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _controller.placeList.value.length,
              itemBuilder: (context, index) {
                String description =
                    _controller.placeList.value[index].description!;
                return ListTile(
                  title: Text(description),
                  onTap: () => close(context, description),
                );
              },
            );
          }
        },
      );
    }
  }
}
