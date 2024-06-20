import 'package:effort/common/widgets/success_screen/success_screen.dart';
import 'package:effort/data/repositories/authentication/authentication_repository.dart';
import 'package:effort/features/authentication/screens/login/login.dart';
import 'package:effort/utils/constants/image_strings.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:effort/utils/popups/loaders.dart';
import 'package:get/get.dart';


class VerifyEmailController extends GetxController {
  VerifyEmailController(this.email);

  static VerifyEmailController get instance => Get.find();

  final String? email;

  @override
  void onInit() {
    sendEmailVerification();
    super.onInit();
  }

  // Send Email Verification Link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification(email!);
      EffortLoaders.successSnackBar(title: 'Email Sent', message: 'Please check your inbox and verify your email.');
    } catch (e) {
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Manually Check If Email Verified
  checkEmailVerificationStatus() async {
    final dark = EffortHelperFunctions.isDarkMode(Get.context!);
    try {
      bool response = await AuthenticationRepository.instance.checkEmailVerified(email!);

      if (response) {

        Get.off(
                () => SuccessScreen(
                image: dark ? EffortImages.successfulIllustrationDark : EffortImages.successfulIllustrationLight,
                title: EffortTexts.yourAccountCreatedTitle,
                subTitle: EffortTexts.yourAccountCreatedSubTitle,
                onPressed: () => Get.offAll(const LoginScreen())
            )
        );
      } else {
        EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Verify your email');
      }

    } catch (e) {
      EffortLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}