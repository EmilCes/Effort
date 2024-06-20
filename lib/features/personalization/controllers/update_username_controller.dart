import 'package:effort/data/repositories/user/user_repository.dart';
import 'package:effort/features/authentication/models/user_credential.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:effort/features/personalization/screens/profile/profile_details.dart';
import 'package:effort/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../authentication/models/user_model.dart';

class UpdateUsernameController extends GetxController {

  static UpdateUsernameController get instance => Get.find();

  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;

  final username = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUsernameFormKey = GlobalKey<FormState>();
  String currentUsername = "";

  @override
  void onInit() {
    initializeUsername();
    super.onInit();
  }

  Future<void> initializeUsername() async {
    currentUsername =  userController.user.value.username!;
    username.text = currentUsername;
  }

  Future<void> updateUsername() async {
    try{
      final dark = EffortHelperFunctions.isDarkMode(Get.context!);

      // Start Loading
      EffortFullScreenLoader.openLoadingDialog('We are updating your information...', dark ? EffortImages.docerAnimationDark : EffortImages.docerAnimationLight);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!updateUsernameFormKey.currentState!.validate()) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Update User Name
      UserModel userToUpdate = userController.user.value;
      userToUpdate.username = username.text.trim();

      await userRepository.updateUserUsername(userToUpdate, currentUsername, credentials!.jwt);

      // Update the Rx User Value
      userController.user.value.username = username.text.trim();

      // Remove loader
      EffortFullScreenLoader.stopLoading();

      // Move to previous screen.
      Get.off(() => const ProfileDetailsScreen());

      // Show Success Message
      EffortLoaders.successSnackBar(title: 'Congruatulations', message: 'Your username has been updated.');

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}