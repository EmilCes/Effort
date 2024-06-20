
import 'package:effort/data/repositories/gym/daily_routine_repository.dart';
import 'package:effort/features/gym/controllers/weekly_routines/weekly_routines_controller.dart';
import 'package:effort/features/gym/models/daily_routine.dart';
import 'package:effort/features/gym/models/exercise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../authentication/models/user_credential.dart';
import '../../../personalization/controllers/user_controller.dart';

class DailyRoutineDetailsController extends GetxController {
  static DailyRoutineDetailsController get instance => Get.find();

  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;

  var dailyRoutineFormKey = GlobalKey<FormState>();
  var routineName = TextEditingController();
  var isEditMode = false.obs;
  var isViewMode = false.obs;
  var isCopyRoutineMode = false.obs;
  var weeklyRoutineMode = false.obs;
  var exercises = <Exercise>[].obs;
  late DailyRoutine dailyRoutine;

  Exercise? temporaryExercise;

  @override
  void onInit() {
    super.onInit();
    if (temporaryExercise != null) {
      addNewExercise(temporaryExercise!);
      temporaryExercise = null;
    }
  }

  Future<void> setDailyRoutine(DailyRoutine dailyRoutine) async {
    exercises.clear();
    this.dailyRoutine= await DailyRoutineRepository.instance.getDailyRoutineById(dailyRoutine.routineId!, credentials!.jwt);
    this.dailyRoutine.day = dailyRoutine.day;
    routineName.text = this.dailyRoutine.name!;
    exercises.addAll(this.dailyRoutine.exercises!);

    isViewMode.value = true;
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    isViewMode.value = !isViewMode.value;
  }

  void addNewExercise(Exercise exercise) {
      exercises.add(exercise);
  }

  void removeExercise(int index) {
    exercises.removeAt(index);
  }

  Future<void> registerDailyRoutine() async {
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
      if (!dailyRoutineFormKey.currentState!.validate()) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Register Daily Routine
      var dailyRoutine = DailyRoutine(name: routineName.text.trim());
      var dailyRoutineRegistered = await DailyRoutineRepository.instance.registerDailyRoutine(dailyRoutine, credentials!.jwt);

      // Register Exercises
      DailyRoutineRepository.instance.registerDailyRoutineExercises(dailyRoutineRegistered.routineId!, formatExercisesList(), credentials!.jwt);

      // Associate Daily Routine With User
      DailyRoutineRepository.instance.registerDailyRoutineUsers(dailyRoutineRegistered.routineId!, credentials!.username, true, credentials!.jwt);

      EffortFullScreenLoader.stopLoading();
      Get.back();
      EffortLoaders.successSnackBar(title: EffortTexts.dailyRoutineRegistered);

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> updateDailyRoutine() async {
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
      if (!dailyRoutineFormKey.currentState!.validate()) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Update Daily Routine
      var dailyRoutine = DailyRoutine(name: routineName.text.trim(), routineId: this.dailyRoutine.routineId);
      await DailyRoutineRepository.instance.updateDailyRoutine(dailyRoutine, credentials!.jwt);

      // Register Exercises
      DailyRoutineRepository.instance.updateDailyRoutineExercises(this.dailyRoutine.routineId!, formatExercisesList(), credentials!.jwt);

      EffortFullScreenLoader.stopLoading();
      Get.back();
      EffortLoaders.successSnackBar(title: EffortTexts.dailyRoutineRegistered);

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> copyRoutine() async {
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

      // Copy Routine
      DailyRoutineRepository.instance.registerDailyRoutineUsers(dailyRoutine.routineId!, credentials!.username, false, credentials!.jwt);

      EffortFullScreenLoader.stopLoading();
      Get.back();
      EffortLoaders.successSnackBar(title: EffortTexts.routineCopied);

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  List<Map<String, dynamic>> formatExercisesList () {
    List<Map<String, dynamic>> formattedExercises = exercises.map((exercise) {
      return {
        "exerciseId": exercise.exerciseId as int,
        "series": exercise.dailyRoutineExercise!.series,
        "repetitions": exercise.dailyRoutineExercise!.repetitions
      };
    }).toList();

    return formattedExercises;
  }

  void addToWeeklyRoutine () {
    final weeklyRoutineController = WeeklyRoutinesController.instance;

    weeklyRoutineController.addDailyRoutine(dailyRoutine);
  }


}
