import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/update_name_controller.dart';

class ChangeName extends StatelessWidget {

  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(UpdateNameController());

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: true,
          title: Text('Change Name', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                EffortTexts.modifyName,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: EffortSizes.spaceBtwSections),

              Form(
                key: controller.updateUserNameFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.firstName,
                      validator: (value) => EffortValidator.validateEmptyText('First Name', value),
                      expands: false,
                      decoration: const InputDecoration(labelText: EffortTexts.firstName, prefixIcon: Icon(Iconsax.user))
                    ),

                    const SizedBox(height: EffortSizes.spaceBtwInputFields),

                    TextFormField(
                        controller: controller.lastName,
                        validator: (value) => EffortValidator.validateEmptyText('Last Name', value),
                        expands: false,
                        decoration: const InputDecoration(labelText: EffortTexts.lastName, prefixIcon: Icon(Iconsax.user))
                    )
                  ],
                ),
              ),

              const SizedBox(height: EffortSizes.spaceBtwSections),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => controller.updateUserName(), child: const Text('Save')),
              )

            ],
        ),
      ),
    );

  }

}