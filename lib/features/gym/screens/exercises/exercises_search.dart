import 'package:effort/features/gym/controllers/exercises/exercise_search_controller.dart';
import 'package:effort/features/gym/screens/exercises/exercises_details.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/popup_menu_button.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/list/effort_list.dart';

class ExercisesSearchScreen extends StatelessWidget {
  const ExercisesSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ExerciseSearchController());

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: true,
        title: const Text('Buscar Ejercicios'),
        actions: [
          EffortPopupMenuButton(
            iconData: Icons.add,
              onSelected: (String result) {
                if (result == 'add_exercise') {
                  Get.to(() => const ExercisesDetailsScreen());
                }
              },
              itemBuilder: (BuildContext context) => const [
                    PopupMenuItem<String>(
                        value: 'add_exercise',
                        child: Text('Agregar nuevo ejercicio'))
                  ])
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          children: [
            // Search Bar
            EffortSearchContainer(
              text: 'Search Exercise',
              icon: Iconsax.search_normal,
              onTextChanged: (searchString) {
                controller.filterResults(searchString);
              },
            ),

            const SizedBox(height: EffortSizes.spaceBtwSections),

            EffortList(
                searchList: controller.searchResults,
                reloadFunction: controller.reloadExercises,
                customListViewBuilder: (context, searchList) {
                  return ListView.builder(
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
                                    ExercisesDetailsScreen(
                                        exercise: item,
                                        isViewMode: true,
                                    ));
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