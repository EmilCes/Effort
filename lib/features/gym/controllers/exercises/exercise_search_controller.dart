import 'package:effort/data/repositories/gym/exercise_repository.dart';
import 'package:effort/features/gym/models/exercise.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../authentication/models/user_credential.dart';
import '../../../personalization/controllers/user_controller.dart';

class ExerciseSearchController extends GetxController {

  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;

  // Variables
  List<Exercise> originalResults = <Exercise>[];
  RxList<Exercise> searchResults = <Exercise>[].obs;

  @override
  void onInit() {
    super.onInit();
    getExercises();
  }

  Future<void> getExercises() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      originalResults = await ExerciseRepository.instance.getExercises(credentials!.jwt);
      searchResults.assignAll(originalResults.obs);

    } catch (e) {
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void filterResults(String searchText) {
    if (searchText.isEmpty) {
      searchResults.assignAll(originalResults.obs);
    } else {
      final filteredResults = originalResults.where((exercise) {
        return exercise.name.toLowerCase().contains(searchText.toLowerCase()) ? true : false;
      }).toList();

      searchResults.assignAll(filteredResults);
    }
  }

  Future<void> reloadExercises() async {
    await getExercises();
  }


}
