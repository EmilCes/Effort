import 'package:effort/utils/constants/image_strings.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {

    final dark = EffortHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          children: [
            // Image
            Image(
              image: AssetImage(dark ? EffortImages.deliveredEmailIllustrationDark : EffortImages.deliveredEmailIllustrationLight),
              width: EffortHelperFunctions.screenWidth() * 0.6,
            ),
            const SizedBox(height: EffortSizes.spaceBtwSections),

            // Title & Subtitle
            Text(EffortTexts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: EffortSizes.spaceBtwItems),
            Text(EffortTexts.changeYourPasswordSubtitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
            const SizedBox(height: EffortSizes.spaceBtwSections),

            // Buttons
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){}, child: const Text(EffortTexts.done))
            ),
            const SizedBox(height: EffortSizes.spaceBtwItems),
            SizedBox(
                width: double.infinity,
                child: TextButton(onPressed: (){}, child: const Text(EffortTexts.resendEmail))
            ),
          ],
        ),
      ),
    );
  }
}
