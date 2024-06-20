import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/features/personalization/controllers/update_weight_controller.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeWeight extends StatelessWidget {

  const ChangeWeight({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(UpdateWeightController());

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: true,
        title: Text('Change Weight', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EffortTexts.modifyWeight,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: EffortSizes.spaceBtwSections),

            Form(
              key: controller.updateWeightFormKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: controller.weight,
                      validator: (value) => EffortValidator.validateWeight(value),
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: EffortTexts.weight,
                          prefixIcon: Icon(Iconsax.weight),
                          suffixText: 'Kg'
                      )
                  )
                ],
              ),
            ),

            const SizedBox(height: EffortSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateWeight(), child: const Text('Save')),
            )

          ],
        ),
      ),
    );

  }

}