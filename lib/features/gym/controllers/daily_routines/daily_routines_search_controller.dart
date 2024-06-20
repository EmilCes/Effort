import 'package:effort/data/repositories/gym/daily_routine_repository.dart';
import 'package:effort/features/gym/models/daily_routine.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../authentication/models/user_credential.dart';
import '../../../personalization/controllers/user_controller.dart';

class DailyRoutinesSearchController extends GetxController {

  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;

  // Variables
  List<DailyRoutine> originalResults = <DailyRoutine>[];
  RxList<DailyRoutine> searchResults = <DailyRoutine>[].obs;
  String username;

  DailyRoutinesSearchController({required this.username});

  Future<void> getDailyRoutines(String username) async {
    try {

      this.username = username;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      //originalResults.clear();
      //searchResults.clear();

      originalResults = await DailyRoutineRepository.instance.getDailyRoutines(username, credentials!.jwt);
      searchResults.assignAll(originalResults.obs);
    } catch (e) {
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void filterResults(String searchText) {
    if (searchText.isEmpty) {
      searchResults.assignAll(originalResults.obs);
    } else {
      final filteredResults = originalResults.where((dailyRoutine) {
        return dailyRoutine.name!
            .toLowerCase()
            .contains(searchText.toLowerCase());
      }).toList();

      searchResults.assignAll(filteredResults);
    }
  }

  Future<void> reloadDailyRoutines() async {
    await getDailyRoutines(username);
  }
}
