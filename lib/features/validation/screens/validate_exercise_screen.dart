import 'package:effort/features/gym/screens/exercises/exercises_details.dart';
import 'package:effort/features/validation/controllers/validate_exercise_controller.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/list/effort_list.dart';
import '../../../utils/constants/colors.dart';

class ValidateExerciseScreen extends StatelessWidget {
  const ValidateExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ValidateExerciseController());

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: false,
        title: Text('Ejercicios por Validar', style: Theme.of(context).textTheme.headlineMedium!.apply(color: EffortColors.white)),
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
                                    isValidateMode: true,
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