import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/features/personalization/controllers/update_bio_controller.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeBio extends StatelessWidget {

  const ChangeBio({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(UpdateBioController());

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: true,
        title: Text('Change Bio', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EffortTexts.modifyBio,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: EffortSizes.spaceBtwSections),

            Form(
              key: controller.updateBioFormKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: controller.bio,
                      validator: (value) => EffortValidator.validateEmptyText('Bio', value),
                      decoration: const InputDecoration(
                          labelText: EffortTexts.bio,
                          prefixIcon: Icon(Iconsax.user)
                      ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline
                  )
                ],
              ),
            ),

            const SizedBox(height: EffortSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateBio(), child: const Text('Save')),
            )

          ],
        ),
      ),
    );

  }

}