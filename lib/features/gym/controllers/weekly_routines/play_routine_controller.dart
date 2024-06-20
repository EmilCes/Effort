import 'dart:async';

import 'package:effort/data/repositories/gym/daily_routine_repository.dart';
import 'package:effort/data/repositories/gym/statistics_repository.dart';
import 'package:effort/features/gym/models/daily_routine.dart';
import 'package:effort/features/gym/models/exercise.dart';
import 'package:effort/features/gym/models/statistic.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muscle_selector/muscle_selector.dart';

import '../../../../data/repositories/gym/exercise_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../authentication/models/user_credential.dart';
import '../../../authentication/models/user_model.dart';

class PlayRoutineController extends GetxController {
  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;
  static UserModel user = UserController.instance.user.value;

  // Variables
  final exerciseName = TextEditingController();
  final exerciseDescription = TextEditingController();
  final series = TextEditingController();
  final repetitions = TextEditingController();
  final int routineId;
  var selectedMuscles = <Muscle>[].obs;
  var isEditMode = false.obs;
  var isViewMode = true.obs;
  var dailyRoutine = Rxn<DailyRoutine>();
  var currentExerciseIndex = 0.obs;
  late int exerciseId;
  late String videoUrl;

  GlobalKey<FormState> exerciseFormKey = GlobalKey<FormState>();
  XFile? video;

  var isPlaying = false.obs;
  var elapsedTime = 0.obs;
  Timer? timer;

  PlayRoutineController({required this.routineId});

  @override
  void onInit() {
    super.onInit();
    fetchDailyRoutine();
  }

  Future<void> endRoutine() async {
    try{

      final dark = EffortHelperFunctions.isDarkMode(Get.context!);

      // Start Loading
      EffortFullScreenLoader.openLoadingDialog('We are processing your information...', dark ? EffortImages.docerAnimationDark : EffortImages.docerAnimationLight);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Time Validation
      if (elapsedTime.value <= 0) {
        EffortFullScreenLoader.stopLoading();
        EffortLoaders.errorSnackBar(title: 'Oh snap!', message: 'You need to start the timer to end the routine.');
        return;
      }

      // Add Date - Time
      Statistic statistic = Statistic(day: DateTime.now(), time: elapsedTime.value ~/ 60);
      StatisticsRepository.instance.addStatistic(statistic, credentials!.username, credentials!.jwt);

      // Remove Loader
      EffortFullScreenLoader.stopLoading();

      Get.back();

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> fetchDailyRoutine() async {
    DailyRoutine fetchedRoutine = await DailyRoutineRepository.instance.getDailyRoutineById(routineId, credentials!.jwt);
    dailyRoutine.value = fetchedRoutine;
    if (fetchedRoutine.exercises != null && fetchedRoutine.exercises!.isNotEmpty) {
      setExercise(fetchedRoutine.exercises![0]);
    }
  }

  Future<void> setExercise(Exercise exercise) async {
    exerciseId = exercise.exerciseId!;
    videoUrl = exercise.videoUrl!;
    exerciseName.text = exercise.name;
    exerciseDescription.text = exercise.description!;
    series.text = exercise.dailyRoutineExercise!.series.toString();
    repetitions.text = exercise.dailyRoutineExercise!.repetitions.toString();
    isEditMode.value = true;
  }

  Future<XFile> getVideoDownloadedFuture(String videoUrl) {
    return ExerciseRepository.instance.downloadVideo(videoUrl, credentials!.jwt);
  }

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    elapsedTime.value = 0;
    isPlaying.value = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime.value += 1;
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    isPlaying.value = false;
  }

  void resetTimer() {
    stopTimer();
    elapsedTime.value = 0;
  }

  void toggleTimer() {
    if (isPlaying.value) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  void nextExercise() {
    if (dailyRoutine.value?.exercises != null && currentExerciseIndex.value < dailyRoutine.value!.exercises!.length - 1) {
      currentExerciseIndex.value++;
      setExercise(dailyRoutine.value!.exercises![currentExerciseIndex.value]);
    }
  }

  void previousExercise() {
    if (dailyRoutine.value?.exercises != null && currentExerciseIndex.value > 0) {
      currentExerciseIndex.value--;
      setExercise(dailyRoutine.value!.exercises![currentExerciseIndex.value]);
    }
  }
}
