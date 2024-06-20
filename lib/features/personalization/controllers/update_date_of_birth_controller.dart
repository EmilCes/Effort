
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

class UpdateDateOfBirthController extends GetxController {

  static UpdateDateOfBirthController get instance => Get.find();

  // Credentials
  static UserCredential? credentials = UserController.instance.userCredential;

  final dateOfBirth = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateDateOfBirthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeDateOfBirth();
    super.onInit();
  }

  Future<void> initializeDateOfBirth() async {
    dateOfBirth.text = userController.user.value.dateOfBirth!;
  }

  Future<void> updateDateOfBirth() async {
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
      if (!updateDateOfBirthFormKey.currentState!.validate()) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Update Date of Birth
      UserModel userToUpdate = userController.user.value;
      userToUpdate.dateOfBirth = dateOfBirth.text;

      await userRepository.updateUser(userToUpdate, credentials!.jwt);

      // Update the Rx User Value
      userController.user.value.dateOfBirth = dateOfBirth.text;

      // Remove loader
      EffortFullScreenLoader.stopLoading();

      // Move to previous screen.
      Get.off(() => const ProfileDetailsScreen());

      // Show Success Message
      EffortLoaders.successSnackBar(title: 'Congruatulations', message: 'Your weight has been updated.');

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}