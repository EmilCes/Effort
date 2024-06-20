import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/features/personalization/controllers/update_height_controller.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeHeight extends StatelessWidget {

  const ChangeHeight({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(UpdateHeightController());

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: true,
        title: Text('Change Height', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EffortTexts.modifyHeight,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: EffortSizes.spaceBtwSections),

            Form(
              key: controller.updateHeightFormKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: controller.height,
                      validator: (value) => EffortValidator.validateHeight(value),
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: EffortTexts.height,
                          prefixIcon: Icon(Iconsax.weight),
                          suffixText: 'Cm'
                      ),
                  )
                ],
              ),
            ),

            const SizedBox(height: EffortSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateHeight(), child: const Text('Save')),
            )

          ],
        ),
      ),
    );

  }

}