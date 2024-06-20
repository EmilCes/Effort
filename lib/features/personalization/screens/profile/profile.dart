import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:effort/common/widgets/sections/section_heading.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:effort/features/personalization/screens/profile/profile_details.dart';
import 'package:effort/features/personalization/screens/profile/widgets/routine_chart.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/image_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserController controller = UserController.instance;

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: false,
        title: Text('Account', style: Theme.of(context).textTheme.headlineMedium!.apply(color: EffortColors.white)),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const ProfileDetailsScreen()),
            icon: const Icon(
              Iconsax.edit,
              color: EffortColors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                const SizedBox(height: EffortSizes.lg),

                Obx(
                  () => EffortUserProfileTile(
                    profilePicture: controller.user.value.profilePicture ?? EffortImages.user,
                    fullName: controller.user.value.fullName,
                    username: controller.user.value.username!,
                    bio: controller.user.value.bio!,
                    followers: 10,
                    following: 100,
                    streak: controller.user.value.streak!,
                    otherProfile: false,
                    onPressed: () => Get.to(() => const ProfileDetailsScreen()),
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(EffortSizes.defaultSpace),
                  child: Column(
                    children: [
                      const EffortSectionHeading(title: 'Rendimiento', showActionButton: false),
                      Obx(() {
                        if (controller.days.isEmpty || controller.times.isEmpty) {
                          return const Center(child: Text("No data available"));
                        }

                        if (controller.times.any((time) => time.isNaN || time.isInfinite)) {
                          return const Center(child: Text("Invalid data: Infinity or NaN found"));
                        }

                        return SizedBox(
                          height: 300,
                          child: RoutineChart(days: controller.days.toList(), times: controller.times.toList()),
                        );
                      })

                    ],
                  ),
                )
              ],
            ),
          )
    );
  }
}
