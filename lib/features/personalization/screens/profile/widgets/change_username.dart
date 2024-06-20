import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/features/personalization/controllers/update_username_controller.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeUsername extends StatelessWidget {

  const ChangeUsername({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(UpdateUsernameController());

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: true,
        title: Text('Change Username', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EffortTexts.modifyUsername,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: EffortSizes.spaceBtwSections),

            Form(
              key: controller.updateUsernameFormKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: controller.username,
                      validator: (value) => EffortValidator.validateEmptyText('Username', value),
                      expands: false,
                      decoration: const InputDecoration(labelText: EffortTexts.username, prefixIcon: Icon(Iconsax.user))
                  )
                ],
              ),
            ),

            const SizedBox(height: EffortSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateUsername(), child: const Text('Save')),
            )

          ],
        ),
      ),
    );

  }

}