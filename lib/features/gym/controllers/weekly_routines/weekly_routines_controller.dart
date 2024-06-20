import 'package:effort/data/repositories/gym/weekly_routine_repository.dart';
import 'package:effort/features/gym/models/daily_routine.dart';
import 'package:effort/features/gym/models/weekly_routine.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:effort/navigation_menu.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/helpers/network_manager.dart';
import 'package:effort/utils/popups/full_screen_loader.dart';
import 'package:effort/utils/popups/loaders.dart';
import 'package:get/get.dart';

import '../../../authentication/models/user_credential.dart';
import '../../../authentication/models/user_model.dart';

class WeeklyRoutinesController extends GetxController {

  static WeeklyRoutinesController get instance => Get.find();

  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;
  static UserModel user = UserController.instance.user.value;

  // Variables
  var weeklyRoutine = WeeklyRoutine.empty().obs;
  var isEditMode = false.obs;
  var isRoutineFound = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWeeklyRoutine();
  }

  Future<void> fetchWeeklyRoutine() async {
    var fetchedRoutine = await WeeklyRoutineRepository.instance.fetchWeeklyRoutineDetails(credentials!.username);

    if (fetchedRoutine.isNotEmpty) {
      var weeklyRoutineList = WeeklyRoutine.fromJson(fetchedRoutine);

      var existingDays = weeklyRoutineList.routines!.map((routine) => routine.day).toList();

      for (var day in WeeklyRoutine.daysOfWeek) {
        if (!existingDays.contains(day)) {
          weeklyRoutineList.routines!.add(DailyRoutine(day: day, routineId: 0, name: ''));
        }
      }

      weeklyRoutineList.routines!.sort((a, b) => WeeklyRoutine.daysOfWeek.indexOf(a.day!).compareTo(WeeklyRoutine.daysOfWeek.indexOf(b.day!)));

      weeklyRoutine.value = weeklyRoutineList;
      isRoutineFound.value = true;
    } else {
      initializeEmptyWeeklyRoutine();
      isRoutineFound.value = false;
    }
  }


  Future<void> registerWeeklyRoutine() async {
    try{
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Register Weekly Routine
      WeeklyRoutineRepository.instance.registerWeeklyRoutine(weeklyRoutine.value, UserController.instance.user.value, credentials!.jwt);

      EffortLoaders.successSnackBar(title: EffortTexts.addToWeeklyRoutineMessage);

    } catch (e) {
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> updateWeeklyRoutine() async {
    try{
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Update Weekly Routine
      WeeklyRoutineRepository.instance.updateWeeklyRoutine(weeklyRoutine.value, UserController.instance.user.value, credentials!.jwt);

      EffortLoaders.successSnackBar(title: EffortTexts.addToWeeklyRoutineMessage);

    } catch (e) {
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void initializeEmptyWeeklyRoutine() {
    weeklyRoutine.value = WeeklyRoutine(
      routines: [
        DailyRoutine(day: 'Monday', routineId: 0, name: ''),
        DailyRoutine(day: 'Tuesday', routineId: 0, name: ''),
        DailyRoutine(day: 'Wednesday', routineId: 0, name: ''),
        DailyRoutine(day: 'Thursday', routineId: 0, name: ''),
        DailyRoutine(day: 'Friday', routineId: 0, name: ''),
        DailyRoutine(day: 'Saturday', routineId: 0, name: ''),
        DailyRoutine(day: 'Sunday', routineId: 0, name: ''),
      ], name: '',
    );
  }

  void addDailyRoutine(DailyRoutine dailyRoutine) {
    int index = weeklyRoutine.value.routines!.indexWhere((routine) => routine.day == dailyRoutine.day);

    if (index != -1) {
      weeklyRoutine.value.routines![index] = dailyRoutine;
    } else {
      weeklyRoutine.value.routines!.add(dailyRoutine);
    }

    if (isRoutineFound.value == false) {
      registerWeeklyRoutine();
    } else {
      updateWeeklyRoutine();
    }

    Get.to(() => const NavigationMenu());
    update();
  }


  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

}