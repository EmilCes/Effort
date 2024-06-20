import 'package:effort/data/repositories/authentication/authentication_repository.dart';
import 'package:effort/navigation_menu.dart';
import 'package:effort/utils/constants/image_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:effort/utils/helpers/network_manager.dart';
import 'package:effort/utils/popups/full_screen_loader.dart';
import 'package:effort/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../personalization/controllers/user_controller.dart';
import '../../screens/signup/verify_email.dart';

class LoginController extends GetxController {

  final userController = Get.put(UserController());

  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();


  @override
  void onInit() {
    var emailFromLocalStorage = localStorage.read('REMEMBER_ME_EMAIL');
    var passwordFromLocalStorage = localStorage.read('REMEMBER_ME_PASSWORD');

    if (emailFromLocalStorage != null && passwordFromLocalStorage != null) {
      email.text = emailFromLocalStorage;
      password.text = passwordFromLocalStorage;
      rememberMe.value = true;
    }

    super.onInit();
  }

  Future<void> signIn() async {
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
      if (!loginFormKey.currentState!.validate()) {
        EffortFullScreenLoader.stopLoading();
        return;
      }

      String emailString = email.text.trim();
      String passwordString = password.text.trim();

      bool response = await AuthenticationRepository.instance.checkEmailVerified(emailString);

      if (!response) {
        Get.to(() => VerifyEmailScreen(email: email.text.trim()));
        return;
      }

      // Save Data If Remember Me Is Selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', emailString);
        localStorage.write('REMEMBER_ME_PASSWORD', passwordString);
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      // Login User
      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(emailString, passwordString);

      userController.userCredential = userCredentials;
      userController.fetchUserData();

      // Remove Loader
      EffortFullScreenLoader.stopLoading();

      // Move to Verify Email Screen
      Get.to(() => const NavigationMenu());

    } catch (e) {
      EffortFullScreenLoader.stopLoading();
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

}