import 'package:effort/features/gym/controllers/daily_routines/daily_routines_search_controller.dart';
import 'package:effort/features/gym/models/daily_routine.dart';
import 'package:effort/features/gym/screens/daily_routines/daily_routines_details.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/popup_menu_button.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/list/effort_list.dart';

class DailyRoutineSearchScreen extends StatelessWidget {
  final String username;
  final bool? otherUserMode;
  final bool? weeklyRoutineMode;
  final String? day;

  const DailyRoutineSearchScreen(
      {super.key, required this.username, this.otherUserMode = false, this.weeklyRoutineMode = false, this.day = ""});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(DailyRoutinesSearchController(username: username));
    controller.getDailyRoutines(username);

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: true,
        title: otherUserMode == true
            ? const Text('Rutinas')
            : const Text('Mis Rutinas'),
        actions: [
          otherUserMode == false
              ? EffortPopupMenuButton(
                  iconData: Icons.add,
                  onSelected: (String result) {
                    if (result == 'add_daily_routine') {
                      Get.to(() => DailyRoutineDetailsScreen());
                    }
                  },
                  itemBuilder: (BuildContext context) => const [
                        PopupMenuItem<String>(
                            value: 'add_daily_routine',
                            child: Text('Agregar nueva rutina'))
                      ])
              : const SizedBox.shrink()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          children: [
            // Search Bar
            EffortSearchContainer(
              text: 'Search Daily Routine',
              icon: Iconsax.search_normal,
              onTextChanged: (searchString) {
                controller.filterResults(searchString);
              },
            ),

            const SizedBox(height: EffortSizes.spaceBtwSections),
            EffortList(
              searchList: controller.searchResults,
              reloadFunction: controller.reloadDailyRoutines,
              customListViewBuilder: (context, searchList) {
                return ListView.builder(
                  itemCount: searchList.length,
                  itemBuilder: (_, index) {
                    final item = searchList[index] as DailyRoutine;
                    item.day = day;
                    return ListTile(
                      title: Text(item.name!,
                          style: const TextStyle(
                              fontSize: EffortSizes.fontSizeSm)),
                      trailing: SizedBox(
                        width: 80,
                        height: 30,
                        child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => otherUserMode == true
                                  ? DailyRoutineDetailsScreen(
                                      dailyRoutine: item,
                                      isCopyRoutineMode: true,
                                      isOwner: item.isOwner,
                                    )
                                  : DailyRoutineDetailsScreen(
                                      dailyRoutine: item,
                                      isOwner: item.isOwner,
                                      weeklyRoutineMode: weeklyRoutineMode!.obs,
                              )
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Ver',
                                style: TextStyle(
                                    fontSize: EffortSizes.fontSizeSm))),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
