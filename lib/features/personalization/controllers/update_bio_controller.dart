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

class UpdateBioController extends GetxController {

  static UpdateBioController get instance => Get.find();

  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;

  final bio = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateBioFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeBio();
    super.onInit();
  }

  Future<void> initializeBio() async {
    bio.text =  userController.user.value.bio!;
  }

  Future<void> updateBio() async {
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
      if (!updateBioFormKey.currentState!.validate()) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Update User Bio
      UserModel userToUpdate = userController.user.value;
      userToUpdate.bio = bio.text.trim();

      await userRepository.updateUser(userToUpdate, credentials!.jwt);

      // Update the Rx User Value
      userController.user.value.bio = bio.text.trim();

      // Remove loader
      EffortFullScreenLoader.stopLoading();

      // Move to previous screen.
      Get.off(() => const ProfileDetailsScreen());

      // Show Success Message
      EffortLoaders.successSnackBar(title: 'Congruatulations', message: 'Your bio has been updated.');

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}