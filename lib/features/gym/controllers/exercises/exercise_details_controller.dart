import 'package:effort/features/gym/controllers/daily_routines/daily_routines_details_controller.dart';
import 'package:effort/features/gym/models/exercise.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/constants/image_strings.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:effort/utils/helpers/network_manager.dart';
import 'package:effort/utils/popups/full_screen_loader.dart';
import 'package:effort/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:path/path.dart' as path;

import '../../../../data/repositories/gym/exercise_repository.dart';
import '../../../authentication/models/user_credential.dart';
import '../../../authentication/models/user_model.dart';
import '../../models/daily_routine_exercise.dart';
import '../../models/muscle.dart';
import '../../screens/exercises/widgets/add_exercise_dialog.dart';

class ExerciseController extends GetxController {

  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;

  static UserModel user = UserController.instance.user.value;

  // Variables
  final exerciseName = TextEditingController();
  final exerciseDescription = TextEditingController();

  var selectedMuscles = <Muscle>[].obs;
  var isEditMode = false.obs;
  var isViewMode = true.obs;
  var isRegisterMode = false.obs;
  var isExerciseOwner = false.obs;
  var isValidateMode = false.obs;
  late int exerciseId;
  late String videoUrl;

  GlobalKey<FormState> exerciseFormKey = GlobalKey<FormState>();
  XFile? video;

  Future<void> registerExercise() async {
    try{
      final dark = EffortHelperFunctions.isDarkMode(Get.context!);

      // Start Loading
      EffortFullScreenLoader.openLoadingDialog('We are uploading your information...', dark ? EffortImages.docerAnimationDark : EffortImages.docerAnimationLight);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!exerciseFormKey.currentState!.validate()) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Register exercise
      videoUrl = '${DateTime.now()}-${exerciseName.text}${path.extension(video!.name)}'.replaceAll(' ', '');
      var exercise = Exercise(name: exerciseName.text.trim(), description: exerciseDescription.text.trim(), videoUrl: videoUrl, creatorId: user.userId);
      var exerciseRegistered = await ExerciseRepository.instance.registerExercise(exercise, credentials!.jwt);

      // Register Muscles
      List<MuscleEffort> muscles = formatMusclesList();
      ExerciseRepository.instance.registerExerciseMuscles(exerciseRegistered.exerciseId!, muscles, credentials!.jwt);

      // Upload Video
      await ExerciseRepository.instance.uploadVideo(video!, videoUrl, credentials!.jwt);

      EffortFullScreenLoader.stopLoading();
      Get.back();
      EffortLoaders.successSnackBar(title: EffortTexts.exerciseRegistered);

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> updateExercise() async {
    try{
      final dark = EffortHelperFunctions.isDarkMode(Get.context!);

      // Start Loading
      EffortFullScreenLoader.openLoadingDialog('We are uploading your information...', dark ? EffortImages.docerAnimationDark : EffortImages.docerAnimationLight);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!exerciseFormKey.currentState!.validate()) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      if (video != null) {
        videoUrl = '${DateTime.now()}-${exerciseName.text}${path.extension(video!.name)}'.replaceAll(' ', '');
      }

      // Update exercise
      var exercise = Exercise(
          exerciseId: exerciseId,
          name: exerciseName.text.trim(),
          description: exerciseDescription.text.trim(),
          videoUrl: videoUrl,
          creatorId: user.userId
      );
      await ExerciseRepository.instance.updateExercise(exercise, credentials!.jwt);

      // Update Muscles
      List<MuscleEffort> muscles = formatMusclesList();
      ExerciseRepository.instance.updateExerciseMuscles(exerciseId, muscles, credentials!.jwt);

      // Upload Video
      if (video != null) {
        await ExerciseRepository.instance.uploadVideo(video!, videoUrl, credentials!.jwt);
      }

      EffortFullScreenLoader.stopLoading();
      toggleEditMode();
      EffortLoaders.successSnackBar(title: EffortTexts.exerciseModified);

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> validateExercise(bool isValid) async {
    try{
      final dark = EffortHelperFunctions.isDarkMode(Get.context!);

      // Start Loading
      EffortFullScreenLoader.openLoadingDialog('We are uploading your information...', dark ? EffortImages.docerAnimationDark : EffortImages.docerAnimationLight);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EffortFullScreenLoader.stopLoading();
        return;
      }


      await ExerciseRepository.instance.validateExercise(exerciseId, isValid, credentials!.jwt);

      EffortFullScreenLoader.stopLoading();
      Get.back();
      EffortLoaders.successSnackBar(title: EffortTexts.validateExerciseCompleted);

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void updateSelectedMuscles(Set<Muscle>? muscles) {
    selectedMuscles.value = muscles?.toList() ?? [];
  }

  void setValidateMode() {
    isValidateMode.value = true;
    isRegisterMode.value = false;
    isViewMode.value = false;
    isEditMode.value = true;
  }

  List<MuscleEffort> formatMusclesList () {
    List<MuscleEffort> muscles = [];
    for (var element in selectedMuscles) {
      String muscleTitle = element.title.replaceAll(RegExp(r'[0-9]'), '');
      if (!muscles.any((muscle) => muscle.name == muscleTitle)) {
        muscles.add(MuscleEffort(name: muscleTitle));
      }
    }

    return muscles;
  }

  Future<void> setExercise(Exercise exercise) async {
    exerciseId = exercise.exerciseId!;
    videoUrl = exercise.videoUrl!;
    exerciseName.text = exercise.name;
    exerciseDescription.text = exercise.description!;
    isEditMode.value = true;

    if (exercise.creatorId == user.userId) {
      isExerciseOwner.value = true;
    }
  }

  Future<XFile> getVideoDownloadedFuture(String videoUrl) {
    return ExerciseRepository.instance.downloadVideo(videoUrl, credentials!.jwt);
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    isViewMode.value = !isViewMode.value;
  }

  void toggleViewMode() {
    isViewMode.value = !isViewMode.value;
  }

  Future<void> showAddExerciseDialog(Exercise exercise) async {
    final seriesController = TextEditingController();
    final repetitionsController = TextEditingController();
    final dark = EffortHelperFunctions.isDarkMode(Get.context!);
    await Get.defaultDialog(
      title: 'Agregar Ejercicio',
      backgroundColor: dark ? EffortColors.dark : EffortColors.white,
      content: AddExerciseDialog(
        seriesController: seriesController,
        repetitionsController: repetitionsController,
        onConfirm: () {
          if (GetUtils.isNum(seriesController.text) &&
              GetUtils.isNum(repetitionsController.text)) {
            final series = int.parse(seriesController.text);
            final repetitions = int.parse(repetitionsController.text);

            final dailyRoutineExercise = DailyRoutineExercise(
              series: series,
              repetitions: repetitions,
            );

            exercise.dailyRoutineExercise = dailyRoutineExercise;
            DailyRoutineDetailsController.instance.addNewExercise(exercise);
            Get.back();
            Get.back();
            Get.back();
          }
        },
      ),
    );
  }
}