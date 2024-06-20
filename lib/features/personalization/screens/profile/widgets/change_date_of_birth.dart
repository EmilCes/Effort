import 'package:effort/common/widgets/appbar/appbar.dart';
import 'package:effort/features/personalization/controllers/update_date_of_birth_controller.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:effort/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';

class ChangeDateOfBirth extends StatelessWidget {

  const ChangeDateOfBirth({super.key});

  @override
  Widget build(BuildContext context) {

    final dark = EffortHelperFunctions.isDarkMode(context);
    final controller = Get.put(UpdateDateOfBirthController());

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: true,
        title: Text('Change Date Of Birth', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EffortTexts.modifyDateOfBirth,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: EffortSizes.spaceBtwSections),

            Form(
              key: controller.updateDateOfBirthFormKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: controller.dateOfBirth,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget? child) {
                              return dark
                                  ? Theme(
                                  data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: EffortColors.darkGrey,
                                        onPrimary: EffortColors.dark,
                                        surface: EffortColors.dark,
                                        onSurface: EffortColors.white,
                                      ),
                                      dialogBackgroundColor: EffortColors.error
                                  ),
                                  child: child!
                              ) : Theme(
                                  data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: EffortColors.darkGrey,
                                        onPrimary: EffortColors.dark,
                                        surface: EffortColors.white,
                                        onSurface: EffortColors.black,
                                      ),
                                      dialogBackgroundColor: EffortColors.error
                                  ),
                                  child: child!
                              );
                            }
                        );

                        if (pickedDate != null) {
                          controller.dateOfBirth.text = "${pickedDate.toLocal()}".split(' ')[0];
                        }
                      },
                      validator: (value) => EffortValidator.validateEmptyText('Date of Birth', value),
                      decoration: const InputDecoration(
                          labelText: EffortTexts.dateOfBirth,
                          prefixIcon: Icon(Iconsax.calendar))
                  ),
                ],
              ),
            ),

            const SizedBox(height: EffortSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateDateOfBirth(), child: const Text('Save')),
            )

          ],
        ),
      ),
    );

  }

}