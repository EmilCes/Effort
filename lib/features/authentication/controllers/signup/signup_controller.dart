import 'package:effort/data/repositories/authentication/authentication_repository.dart';
import 'package:effort/features/authentication/models/user_model.dart';
import 'package:effort/features/authentication/models/user_type.dart';
import 'package:effort/features/authentication/screens/signup/verify_email.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:effort/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';

class SignupController extends GetxController {

  static SignupController get instance => Get.find(); // Singleton

  // Variables
  final hidePassword = true.obs; // obs create an observable
  final privacyPolicy = false.obs;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final dateOfBirth = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async {
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

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        EffortFullScreenLoader.stopLoading();
        EffortLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to create an account, you must have to read and accept the Privacy Policy & Terms of Use.'
        );

        return;
      }

      // Save Authenticated user data
      final userToRegister = UserModel(
          email: email.text.trim(),
          username: username.text.trim(),
          userType: UserType.BodyBuilder.name,
          name: firstName.text.trim(),
          dateOfBirth: dateOfBirth.text,
          lastname: lastName.text.trim(),
          password: password.text.trim()
      );

      // Register User
      await AuthenticationRepository.instance.registerUser(userToRegister);

      // Show Success Message
      //EffortLoaders.successSnackBar(title: 'Congruatulations', message: "Your account has been created! Verify email to continue. ");

      // Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));


    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

}