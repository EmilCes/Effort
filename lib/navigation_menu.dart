import 'package:effort/features/authentication/models/user_credential.dart';
import 'package:effort/features/gym/screens/weekly_routines/weekly_routines_details.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:effort/features/personalization/screens/profile/profile.dart';
import 'package:effort/features/users/screens/users_search.dart';
import 'package:effort/features/validation/screens/validate_exercise_screen.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final userCredentials = UserController.instance.userCredential!;
    final controller = Get.put(NavigationController(userCredentials));
    final dark = EffortHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: dark ? EffortColors.darkBackground : EffortColors.white,
          indicatorColor: EffortColors.primary.withOpacity(0.2),
          destinations: controller.destinations,
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final List<Widget> screens;
  final List<NavigationDestination> destinations;

  NavigationController(UserCredential userCredential)
      : screens = userCredential.rol == 'BodyBuilder'
      ? [
    //const HomeScreen(),
    WeeklyRoutineScreen(isPlayMode: true),
    WeeklyRoutineScreen(),
    const UsersSearchScreen(),
    const ProfileScreen(),
  ]
      : [
    //const HomeScreen(),
    WeeklyRoutineScreen(isPlayMode: true),
    WeeklyRoutineScreen(),
    const UsersSearchScreen(),
    const ValidateExerciseScreen(),
    const ProfileScreen()
  ],
        destinations = userCredential.rol == 'BodyBuilder'
            ? const [
          NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
          NavigationDestination(icon: Icon(Iconsax.weight4), label: 'Routines'),
          NavigationDestination(icon: Icon(Iconsax.search_normal), label: 'Search'),
          NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
        ]
            : const [
          NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
          NavigationDestination(icon: Icon(Iconsax.weight4), label: 'Routines'),
          NavigationDestination(icon: Icon(Iconsax.search_normal), label: 'Search'),
          NavigationDestination(icon: Icon(Iconsax.tick_circle), label: 'Validate'),
          NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
        ];
}
