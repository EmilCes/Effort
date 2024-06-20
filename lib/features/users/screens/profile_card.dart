import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:effort/common/widgets/sections/section_heading.dart';
import 'package:effort/features/authentication/models/user_model.dart';
import 'package:effort/features/personalization/screens/profile/profile_details.dart';
import 'package:effort/features/users/controllers/user_card_controller.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../gym/screens/daily_routines/daily_routines_search.dart';
import '../../personalization/screens/profile/widgets/routine_chart.dart';

class ProfileCardScreen extends StatelessWidget {
  final UserModel user;

  const ProfileCardScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchUserData(user.username!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: EffortAppBar(
              showBackArrow: false,
              title: Text(
                'Perfil',
                style: Theme.of(context).textTheme.headlineMedium!.apply(color: EffortColors.white),
              ),
              actions: [
                IconButton(
                  onPressed: () => Get.to(() => const ProfileDetailsScreen()),
                  icon: const Icon(
                    Iconsax.edit,
                    color: EffortColors.white,
                  ),
                )
              ],
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: EffortAppBar(
              showBackArrow: false,
              title: Text(
                'Perfil',
                style: Theme.of(context).textTheme.headlineMedium!.apply(color: EffortColors.white),
              ),
              actions: [
                IconButton(
                  onPressed: () => Get.to(() => const ProfileDetailsScreen()),
                  icon: const Icon(
                    Iconsax.edit,
                    color: EffortColors.white,
                  ),
                )
              ],
            ),
            body: const Center(
              child: Text('Error al cargar los datos'),
            ),
          );
        } else {
          return _buildProfileScreen(context);
        }
      },
    );
  }

  Future<void> _fetchUserData(String username) async {
    try {
      final controller = Get.put(UserCardController());
      await controller.fetchUserData(username);
    } catch (e) {
      throw Exception('Error al recuperar los datos del usuario');
    }
  }

  Widget _buildProfileScreen(BuildContext context) {
    final controller = UserCardController.instance;
    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: true,
        title: const Text('Perfil'),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const ProfileDetailsScreen()),
            icon: const Icon(
              Iconsax.edit,
              color: EffortColors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const SizedBox(height: EffortSizes.lg),
            GetX<UserCardController>(
              init: controller,
              builder: (_) => EffortUserProfileTile(
                profilePicture: _.user.value.profilePicture == '' ? EffortImages.user : _.user.value.profilePicture!,
                fullName: '${_.user.value.name ?? ''} ${_.user.value.lastname ?? ''}' ,
                username: _.user.value.username ?? '',
                bio: _.user.value.bio ?? '',
                followers: 10,
                following: 100,
                streak: _.user.value.streak ?? 0,
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
                  }),
                  const SizedBox(height: EffortSizes.spaceBtwSections),
                  EffortSectionHeading(title: 'Rutinas', buttonTitle: 'Ver Rutinas', onPressed: () {
                        final String username = user.username!;
                        Get.to(() => DailyRoutineSearchScreen(username: username, otherUserMode: true));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
