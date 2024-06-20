/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/gym/screens/exercises/exercises_details.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class EffortList extends StatelessWidget {
  const EffortList({
    super.key,
    required this.searchList,
    required this.reloadFunction,
    required this.buttonName
  });

  final RxList<dynamic> searchList;
  final Future<void> Function() reloadFunction;
  final String buttonName;

  @override
  Widget build(BuildContext context) {

    final dark = EffortHelperFunctions.isDarkMode(context);

    return Expanded(
      child: Obx(() {
        if (searchList.isEmpty) {
          return const Center(child: Text('No results found'));
        }
        return RefreshIndicator(
          color: EffortColors.primary,
          backgroundColor: dark ? EffortColors.darkBackground : EffortColors.white,
          onRefresh: () async {
            await reloadFunction();
          },
          child: ListView.builder(
            itemCount: searchList.length,
            itemBuilder: (_, index) {
              final item = searchList[index];
              return ListTile(
                title: Text(item.name,
                    style: const TextStyle(
                        fontSize: EffortSizes.fontSizeSm)),
                trailing: SizedBox(
                  width: 80,
                  height: 30,
                  child: ElevatedButton(
                      onPressed: () {
                        Get.to(() =>
                            ExercisesDetailsScreen(exercise: item));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(buttonName,
                          style: const TextStyle(
                              fontSize: EffortSizes.fontSizeSm))),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class EffortList extends StatelessWidget {
  const EffortList({
    super.key,
    required this.searchList,
    required this.reloadFunction,
    required this.customListViewBuilder,
  });

  final RxList<dynamic> searchList;
  final Future<void> Function() reloadFunction;
  final ListView Function(BuildContext, RxList<dynamic>) customListViewBuilder;

  @override
  Widget build(BuildContext context) {

    final dark = EffortHelperFunctions.isDarkMode(context);

    return Expanded(
      child: Obx(() {
        if (searchList.isEmpty) {
          return const Center(child: Text('No results found'));
        }
        return RefreshIndicator(
          color: EffortColors.primary,
          backgroundColor: dark ? EffortColors.darkBackground : EffortColors.white,
          onRefresh: () async {
            await reloadFunction();
          },
          child: customListViewBuilder(context, searchList),
        );
      }),
    );
  }
}

