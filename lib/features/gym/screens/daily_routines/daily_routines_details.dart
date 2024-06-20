import 'package:effort/features/gym/controllers/daily_routines/daily_routines_details_controller.dart';
import 'package:effort/features/gym/models/daily_routine.dart';
import 'package:effort/features/gym/screens/daily_routines/widgets/exercise_container.dart';
import 'package:effort/features/gym/screens/exercises/exercises_details.dart';
import 'package:effort/features/gym/screens/exercises/exercises_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/popup_menu_button.dart';
import '../../../../common/widgets/sections/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';

class DailyRoutineDetailsScreen extends StatelessWidget {
  final DailyRoutine? dailyRoutine;
  final bool? isCopyRoutineMode;
  final bool? isOwner;
  late Rx<bool>? weeklyRoutineMode;

  DailyRoutineDetailsScreen(
      {super.key,
      this.dailyRoutine,
      this.isCopyRoutineMode = false,
      this.isOwner,
      this.weeklyRoutineMode});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DailyRoutineDetailsController());

    if (dailyRoutine != null) {
      controller.setDailyRoutine(dailyRoutine!);
      controller.isCopyRoutineMode = isCopyRoutineMode!.obs;
    }

    if (weeklyRoutineMode != null) {
      controller.weeklyRoutineMode.value = weeklyRoutineMode!.value;
    }

    return Scaffold(
      appBar: EffortAppBar(
          showBackArrow: true,
          title: dailyRoutine != null
              ? const Text('Rutina')
              : const Text('Nueva Rutina'),
          actions: dailyRoutine != null &&
                  isCopyRoutineMode == false &&
                  isOwner == true
              ? [
                  Obx(
                    () => EffortPopupMenuButton(
                        iconData: controller.isEditMode.value
                            ? Icons.cancel
                            : Icons.edit,
                        onSelected: (String result) {
                          if (result == 'modify_exercise') {
                            controller.toggleEditMode();
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                  value: 'modify_exercise',
                                  child: Text(controller.isEditMode.value
                                      ? 'Cancelar'
                                      : 'Modificar Ejercicio'))
                            ]),
                  )
                ]
              : null),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EffortSizes.defaultSpace),
          child: Column(
            children: [
              Form(
                key: controller.dailyRoutineFormKey,
                child: Column(
                  children: [
                    Obx(
                      () => TextFormField(
                        controller: controller.routineName,
                        validator: (value) => EffortValidator.validateEmptyText(
                            EffortTexts.routineName, value),
                        readOnly: controller.isViewMode.value,
                        decoration: const InputDecoration(
                          labelText: EffortTexts.routineName,
                          prefixIcon: Icon(Iconsax.routing),
                        ),
                      ),
                    ),
                    const SizedBox(height: EffortSizes.spaceBtwSections),
                    const EffortSectionHeading(
                        title: 'Ejercicios', showActionButton: false),
                    Obx(() {
                      final exercises = controller.exercises;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            controller.isEditMode.value || dailyRoutine == null
                                ? exercises.length + 1
                                : exercises.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < exercises.length) {
                            final exercise = exercises[index];
                            return ExerciseContainer(
                              exercise: exercise,
                              isLast: index == exercises.length - 1,
                              onTap: () {
                                if (index == exercises.length - 1 &&
                                    exercise.name.isNotEmpty) {
                                  Get.to(() => ExercisesDetailsScreen(
                                      exercise: exercise, isConsultMode: true));
                                }
                              },
                              onDelete: controller.isEditMode.value
                                  ? () => controller.removeExercise(index)
                                  : null,
                            );
                          } else {
                            if (controller.isEditMode.value ||
                                dailyRoutine == null) {
                              return ExerciseContainer(
                                isLast: true,
                                onTap: () {
                                  if (exercises.isEmpty ||
                                      exercises.last.name.isNotEmpty) {
                                    Get.to(() => const ExercisesSearchScreen());
                                    //controller.addNewExercise();
                                  }
                                },
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                        },
                      );
                    }),
                    if (controller.isEditMode.value == false && dailyRoutine == null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.registerDailyRoutine(),
                          child: const Text(EffortTexts.registerRoutine),
                        ),
                      ),
                    Obx(() {
                      if (controller.isEditMode.value == true &&
                          dailyRoutine != null) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.updateDailyRoutine(),
                            child: const Text(EffortTexts.modifyRoutine),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    Obx(() {
                      if (controller.isEditMode.value == false &&
                          controller.isCopyRoutineMode.value == true) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.copyRoutine(),
                            child: const Text(EffortTexts.copyRoutine),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    Obx(() {
                      if (controller.weeklyRoutineMode.value == true && controller.isEditMode.value == false) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.addToWeeklyRoutine(),
                            child: const Text(EffortTexts.addToWeeklyRoutine),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
