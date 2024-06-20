import 'package:effort/data/repositories/user/user_repository.dart';
import 'package:effort/features/authentication/models/user_model.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../authentication/models/user_credential.dart';
import '../../personalization/controllers/user_controller.dart';

class UserSearchController extends GetxController {

  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;

  // Variables
  List<UserModel> searchResults = <UserModel>[];
  RxList<UserModel> searchResultsObs = <UserModel>[].obs;

  Future<void> getUserBySearchWord(String searchWord) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      searchResults = await UserRepository.instance.getUsersBySearchWord(searchWord, credentials!.jwt);
      searchResultsObs.assignAll(searchResults.obs);

    } catch (e) {
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> reloadUsers() async {
    await getUserBySearchWord('');
  }

}
