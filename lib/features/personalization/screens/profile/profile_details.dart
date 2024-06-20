import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/common/widgets/images/effort_circular_image.dart';
import 'package:effort/common/widgets/sections/section_heading.dart';
import 'package:effort/features/authentication/screens/login/login.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:effort/features/personalization/screens/profile/widgets/change_bio.dart';
import 'package:effort/features/personalization/screens/profile/widgets/change_date_of_birth.dart';
import 'package:effort/features/personalization/screens/profile/widgets/change_height.dart';
import 'package:effort/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:effort/features/personalization/screens/profile/widgets/change_username.dart';
import 'package:effort/features/personalization/screens/profile/widgets/change_weight.dart';
import 'package:effort/navigation_menu.dart';
import 'package:effort/utils/constants/image_strings.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/formatters/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'widgets/profile_menu.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = UserController.instance;

    return Scaffold(
      appBar: EffortAppBar(
        leadingIcon: Iconsax.arrow_left,
        leadingOnPressed: () => Get.off(() => const NavigationMenu()),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(EffortSizes.defaultSpace),
          child: Column(
            children: [

              // Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final userImage = controller.user.value.profilePicture;
                      final image = userImage ?? EffortImages.user;
                      return  EffortCircularImage(image: image, width: 80, height: 80, padding: 0,);
                    }),
                    TextButton(
                        onPressed: () => controller.uploadUserProfilePicture(), child: const Text('Change Profile Picture'))
                  ],
                ),
              ),

              // Details
              const SizedBox(height: EffortSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: EffortSizes.spaceBtwItems),

              // Heading Profile Info
              const EffortSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: EffortSizes.spaceBtwItems),

              EffortProfileMenu(title: 'Name', value: controller.user.value.fullName, onPressed: () => Get.to(() => const ChangeName())),
              EffortProfileMenu(title: 'Username', value: controller.user.value.username!, onPressed: () => Get.to(() => const ChangeUsername())),
              EffortProfileMenu(title: 'Bio', value: controller.user.value.bio!, onPressed: () => Get.to(() => const ChangeBio())),

              const SizedBox(height: EffortSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: EffortSizes.spaceBtwItems),

              // Heading Personal Info
              const EffortSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: EffortSizes.spaceBtwItems),

              EffortProfileMenu(title: 'E-mail', value: controller.user.value.email!, showIcon: false, onPressed: () {}),
              EffortProfileMenu(
                  title: 'Date of Birth', 
                  value: EffortFormatter.formatDateToDateName(controller.user.value.dateOfBirth!),
                  onPressed: () => Get.to(() => const ChangeDateOfBirth())),
              EffortProfileMenu(
                  title: 'Weight',
                  value: controller.user.value.weight == 0.0 ? 'Sin peso registrado' : controller.user.value.weight.toString(),
                  onPressed: () => Get.to(() => const ChangeWeight())
              ),
              EffortProfileMenu(
                  title: 'Height',
                  value:  controller.user.value.height == 100 ? 'Sin altura registrada' : controller.user.value.height.toString(),
                  onPressed: () => Get.to(() => const ChangeHeight())
              ),
              const Divider(),
              const SizedBox(height: EffortSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: ()  => Get.offAll(() => const LoginScreen()),
                  child: const Text('Close Account', style: TextStyle(color: Colors.red)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


