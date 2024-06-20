import 'package:effort/common/widgets/appbar/popup_menu_button.dart';
import 'package:effort/features/gym/screens/exercises/widgets/muscles_selector.dart';
import 'package:effort/features/gym/screens/exercises/widgets/video_player.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muscle_selector/muscle_selector.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/exercises/exercise_details_controller.dart';
import '../../models/exercise.dart';

class ExercisesDetailsScreen extends StatelessWidget {
  final Exercise? exercise;
  final bool isViewMode;
  final bool isValidateMode;
  final bool? isConsultMode;

  const ExercisesDetailsScreen(
      {super.key, this.exercise, this.isViewMode = false, this.isValidateMode = false, this.isConsultMode = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExerciseController());
    final videoNotifier = ValueNotifier<XFile?>(null);
    final videoFuture = exercise != null
        ? controller.getVideoDownloadedFuture(exercise!.videoUrl!)
        : Future.value(null);

    if (exercise != null) {
      controller.setExercise(exercise!);

      if (isValidateMode == true) {
        controller.setValidateMode();
      }
    } else {
      controller.isRegisterMode.value = true;
    }

    return Scaffold(
      appBar: EffortAppBar(
          showBackArrow: true,
          title: exercise != null
              ? const Text('Ejercicio')
              : const Text('Nuevo Ejercicio'),
          actions: exercise != null && controller.isExerciseOwner.value == true && controller.isValidateMode.value == false
              ? [
                  Obx(
                    () => EffortPopupMenuButton(
                        iconData: controller.isEditMode.value
                            ? Icons.edit
                            : Icons.cancel,
                        onSelected: (String result) {
                          if (result == 'modify_exercise') {
                            controller.toggleEditMode();
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                  value: 'modify_exercise',
                                  child: Text(controller.isEditMode.value
                                      ? 'Modificar Ejercicio'
                                      : 'Cancelar'))
                            ]),
                  )
                ]
              : null),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EffortSizes.defaultSpace),
          child: Column(children: [
            Form(
              key: controller.exerciseFormKey,
              child: Column(
                children: [
                  if (exercise != null)
                    FutureBuilder<XFile?>(
                        future: videoFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                                color: EffortColors.primary);
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            final video = snapshot.data;
                            return Obx(() => VideoPlayerWidget(
                                  videoNotifier: videoNotifier,
                                  video: video,
                                  isEditing: !controller.isEditMode.value,
                                ));
                          }
                        })
                  else
                    Obx(() => VideoPlayerWidget(
                          videoNotifier: videoNotifier,
                          isEditing: controller.isEditMode.value,
                        )),

                  const SizedBox(height: EffortSizes.spaceBtwSections),

                  ValueListenableBuilder<XFile?>(
                    valueListenable: videoNotifier,
                    builder: (context, video, child) {
                      if (video != null) {
                        controller.video = video;
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  // Exercise Name
                  Obx(
                    () => TextFormField(
                      controller: controller.exerciseName,
                      validator: (value) => EffortValidator.validateEmptyText(
                          'Exercise Name', value),
                      readOnly: controller.isEditMode.value,
                      decoration: const InputDecoration(
                        labelText: EffortTexts.exerciseName,
                        prefixIcon: Icon(Iconsax.mask),
                      ),
                    ),
                  ),

                  const SizedBox(height: EffortSizes.spaceBtwInputFields),

                  Obx(
                    () => TextFormField(
                      controller: controller.exerciseDescription,
                      validator: (value) => EffortValidator.validateEmptyText(
                          'Exercise Description', value),
                      readOnly: controller.isEditMode.value,
                      decoration: const InputDecoration(
                        labelText: EffortTexts.exerciseDescription,
                        prefixIcon: Icon(CupertinoIcons.question_square),
                      ),
                    ),
                  ),

                  const SizedBox(height: EffortSizes.spaceBtwSections),

                  if (exercise != null)
                    Obx(
                      () => MuscleSelectorWidget(
                        onChanged: (selectedMuscles) {
                          controller.updateSelectedMuscles(
                              selectedMuscles?.cast<Muscle>());
                        },
                        isEditMode: controller.isEditMode.value,
                        initializeMusclesGroups:
                            exercise!.muscles!.map((e) => e.name).toList(),
                      ),
                    )
                  else
                    MuscleSelectorWidget(
                        onChanged: (selectedMuscles) {
                          controller.updateSelectedMuscles(
                              selectedMuscles?.cast<Muscle>());
                        },
                        isEditMode: false),

                  const SizedBox(height: EffortSizes.spaceBtwSections),

                  if (controller.isEditMode.value == false && controller.isRegisterMode.value == true)
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.registerExercise(),
                          child: const Text(EffortTexts.registerExercise),
                        )),

                  Obx(() {
                    if (controller.isEditMode.value == false && exercise != null && controller.isViewMode.value == false && controller.isValidateMode.value == false) {
                      return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.updateExercise(),
                            child: const Text(EffortTexts.modifyExercise),
                          ));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),

                  Obx(() {
                    if (controller.isViewMode.value == true && controller.isRegisterMode.value == false && isConsultMode == false) {
                      return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.showAddExerciseDialog(exercise!);
                            },
                            child: const Text(EffortTexts.addExercise),
                          ));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),

                  Obx(() {
                    if (controller.isViewMode.value == false && controller.isValidateMode.value == true) {
                      return Column(
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.validateExercise(true);
                                },
                                child: const Text(EffortTexts.validateExercise),
                              )),

                          const SizedBox(height: EffortSizes.spaceBtwInputFields),

                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.redAccent,
                                  elevation: 5,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: const BorderSide(color: Colors.redAccent, width: 2.0),
                                  ),
                                ),
                                onPressed: () {
                                  controller.validateExercise(false);
                                },
                                child: const Text(EffortTexts.notValidateExercise),
                              )),
                        ]
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  })
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
