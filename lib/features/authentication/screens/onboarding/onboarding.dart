import 'package:effort/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:effort/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:effort/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:effort/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:effort/utils/constants/image_strings.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'widgets/onboarding_next.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(OnBoardingController());
    final dark = EffortHelperFunctions.isDarkMode(context);

    return Scaffold(
        body: Stack(
          children: [
            // Horizontal Scrollable Pages
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              children: [
                OnBoardingPage(
                  image: dark ? EffortImages.onBoardingImage1Dark : EffortImages.onBoardingImage1Light,
                  title: EffortTexts.onBoardingTitle1,
                  subtitle: EffortTexts.onBoardingSubTitle1,
                ),
                OnBoardingPage(
                  image: dark ? EffortImages.onBoardingImage2Dark : EffortImages.onBoardingImage2Light,
                  title: EffortTexts.onBoardingTitle2,
                  subtitle: EffortTexts.onBoardingSubTitle2,
                ),
                OnBoardingPage(
                  image: dark ? EffortImages.onBoardingImage3Dark : EffortImages.onBoardingImage3Light,
                  title: EffortTexts.onBoardingTitle3,
                  subtitle: EffortTexts.onBoardingSubTitle3,
                ),
              ],
            ),

            // Skip Button
            const OnBoardingSkip(),
            
            // Dot Navigation SmoothPageIndicator
            const OnBoardingDotNavigation(),
            
            // Circular Button
            const OnBoardingNextButton()
          ],
        ),
    );
  }
}


