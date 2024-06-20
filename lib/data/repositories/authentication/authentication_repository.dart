import 'package:effort/features/authentication/models/user_credential.dart';
import 'package:effort/features/authentication/models/user_model.dart';
import 'package:effort/features/authentication/screens/onboarding/onboarding.dart';
import 'package:effort/utils/http/http_client.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../features/authentication/screens/login/login.dart';

class AuthenticationRepository extends GetxController {

  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
      // Local Storage
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(const OnBoardingScreen());
  }

  /* ------------------------ Email & Password Sign In --------------------------- */

  // Login
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      const endpoint = 'api/auth';

      Map<String, String> authRequest = {
        'email': email,
        'password': password
      };

      var response = await EffortHttpHelper.post(endpoint, authRequest, null);
      return UserCredential.fromJson(response);

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // Register User
  Future<void> registerUser(UserModel userModel) async {
    try {
      const endpoint = 'api/users';
      await EffortHttpHelper.post(endpoint, userModel.toJson(), null);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // Mail Verification
  Future<void> sendEmailVerification(String userEmail) async {
    try {
      var endpoint = 'api/user-verification/$userEmail';
      await EffortHttpHelper.post(endpoint, null, null);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // Email Verified
  Future<bool> checkEmailVerified(String userEmail) async {
    try {
      var endpoint = 'api/user-verification/verified/$userEmail';
      var response = await EffortHttpHelper.get(endpoint, null);

      return response['isVerified'] as bool;

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}