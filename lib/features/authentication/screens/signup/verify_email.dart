import 'package:effort/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:effort/features/authentication/screens/login/login.dart';
import 'package:effort/utils/constants/image_strings.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(VerifyEmailController(email));

    final dark = EffortHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.offAll(() => const LoginScreen()), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(EffortSizes.defaultSpace),
            child: Column(
              children: [
                // Image
                Image(
                  image: AssetImage(
                      dark ? EffortImages.deliveredEmailIllustrationDark : EffortImages.deliveredEmailIllustrationLight
                  ),
                  width: EffortHelperFunctions.screenWidth() * 0.6,
                ),
                const SizedBox(height: EffortSizes.spaceBtwSections),

                // Title & Subtitle
                Text(EffortTexts.confirmEmail, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: EffortSizes.spaceBtwItems),
                Text(email ?? '', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
                const SizedBox(height: EffortSizes.spaceBtwItems),
                Text(EffortTexts.confirmEmailSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
                const SizedBox(height: EffortSizes.spaceBtwSections),

                // Buttons
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => controller.checkEmailVerificationStatus(),
                        child: const Text(EffortTexts.effortContinue))),
                const SizedBox(height: EffortSizes.spaceBtwItems),
                SizedBox(width: double.infinity, child: TextButton(onPressed: () => controller.sendEmailVerification(), child: const Text(EffortTexts.resendEmail))),



              ],
            ),
        ),
      ),
    );
  }
}
