import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EffortHomeAppBar extends StatelessWidget {

  const EffortHomeAppBar({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    UserController controller = Get.find();

    return EffortAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(controller.user.value.userType!, style: Theme.of(context).textTheme.labelMedium!.apply(color: EffortColors.grey))),
          Obx(() => Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: EffortColors.white))),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(onPressed: (){}, icon: const Icon(Iconsax.shopping_bag, color: EffortColors.white)),
          ],
        )
      ],
    );
  }
}