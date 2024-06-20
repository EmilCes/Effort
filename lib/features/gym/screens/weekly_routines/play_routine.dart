import 'package:effort/features/gym/screens/exercises/widgets/video_player.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/weekly_routines/play_routine_controller.dart';
import '../../models/exercise.dart';

class PlayRoutineScreen extends StatelessWidget {
  final Exercise? exercise;
  final int routineId;

  const PlayRoutineScreen({super.key, this.exercise, required this.routineId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayRoutineController(routineId: routineId));
    final videoNotifier = ValueNotifier<XFile?>(null);

    return Scaffold(
      appBar: const EffortAppBar(showBackArrow: true, title: Text('Start Routine')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EffortSizes.defaultSpace),
          child: Column(children: [
            Obx(() {
              if (controller.dailyRoutine.value == null) {
                return const Center(
                  child: CircularProgressIndicator(color: EffortColors.primary),
                );
              }

              return Form(
                key: controller.exerciseFormKey,
                child: Column(
                  children: [
                    Obx(() {
                      final exercise = controller.dailyRoutine.value?.exercises?[controller.currentExerciseIndex.value];
                      final videoFuture = exercise != null
                          ? controller.getVideoDownloadedFuture(exercise.videoUrl!)
                          : Future.value(null);

                      return FutureBuilder<XFile?>(
                        future: videoFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(color: EffortColors.primary);
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
                        },
                      );
                    }),
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
                        validator: (value) => EffortValidator.validateEmptyText('Exercise Name', value),
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
                        validator: (value) => EffortValidator.validateEmptyText('Exercise Description', value),
                        readOnly: controller.isEditMode.value,
                        decoration: const InputDecoration(
                          labelText: EffortTexts.exerciseDescription,
                          prefixIcon: Icon(CupertinoIcons.question_square),
                        ),
                      ),
                    ),
                    const SizedBox(height: EffortSizes.spaceBtwInputFields),
                    Obx(() => Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.series,
                            readOnly: controller.isEditMode.value,
                            decoration: const InputDecoration(
                              labelText: EffortTexts.series,
                              prefixIcon: Icon(CupertinoIcons.question_square),
                            ),
                          ),
                        ),
                        const SizedBox(width: EffortSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            controller: controller.repetitions,
                            readOnly: controller.isEditMode.value,
                            decoration: const InputDecoration(
                              labelText: EffortTexts.repetitions,
                              prefixIcon: Icon(CupertinoIcons.question_square),
                            ),
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 96),
                    Obx(() {
                      final elapsedMinutes = (controller.elapsedTime.value / 60).floor().toString().padLeft(2, '0');
                      final elapsedSeconds = (controller.elapsedTime.value % 60).toString().padLeft(2, '0');
                      return Text('$elapsedMinutes:$elapsedSeconds', style: Theme.of(context).textTheme.headlineMedium!.apply(color: EffortColors.white));
                    }),
                    const SizedBox(height: 96),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.previousExercise,
                            child: const Text(EffortTexts.backRoutine),
                          ),
                        ),
                        const SizedBox(width: EffortSizes.spaceBtwInputFields),
                        Expanded(
                          child: Obx(() {
                            return ElevatedButton(
                              onPressed: controller.toggleTimer,
                              child: Text(controller.isPlaying.value ? EffortTexts.stopRoutine : EffortTexts.playRoutine),
                            );
                          }),
                        ),
                        const SizedBox(width: EffortSizes.spaceBtwInputFields),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.nextExercise,
                            child: const Text(EffortTexts.nextRoutine),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: EffortSizes.spaceBtwItems),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => controller.endRoutine(),
                            child: const Text(EffortTexts.endRoutine))),
                  ],
                ),
              );
            }),
          ]),
        ),
      ),
    );
  }
}
