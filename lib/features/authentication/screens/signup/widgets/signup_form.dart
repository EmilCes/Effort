import 'package:effort/features/authentication/controllers/signup/signup_controller.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:effort/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'terms_conditions_checkbox.dart';

class EffortSignupForm extends StatelessWidget {
  const EffortSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final dark = EffortHelperFunctions.isDarkMode(context);
    final controller = Get.put(SignupController());

    return Form(
      key: controller.signupFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    validator: (value) => EffortValidator.validateEmptyText('First Name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: EffortTexts.firstName,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
                ),
                const SizedBox(width: EffortSizes.spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    validator: (value) => EffortValidator.validateEmptyText('Last Name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: EffortTexts.lastName,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: EffortSizes.spaceBtwInputFields),

            // Username
            TextFormField(
              controller: controller.username,
              validator: (value) => EffortValidator.validateEmptyText('Username', value),
              expands: false,
              decoration: const InputDecoration(
                  labelText: EffortTexts.username,
                  prefixIcon: Icon(Iconsax.user_edit)),
            ),
            const SizedBox(height: EffortSizes.spaceBtwInputFields),

            // Email
            TextFormField(
              controller: controller.email,
              validator: (value) => EffortValidator.validateEmail(value),
              decoration: const InputDecoration(
                  labelText: EffortTexts.email,
                  prefixIcon: Icon(Iconsax.direct)),
            ),
            const SizedBox(height: EffortSizes.spaceBtwInputFields),

            // Date Of Birth
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
            const SizedBox(height: EffortSizes.spaceBtwInputFields),

            // Password
            Obx(
              () =>  TextFormField(
                controller: controller.password,
                validator: (value) => EffortValidator.validatePassword(value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                    labelText: EffortTexts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                      icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)
                    ),
                ),
              ),
            ),
            const SizedBox(height: EffortSizes.spaceBtwSections),

            // Terms&Conditions Checkbox
            const EffortTemsAndConditionCheckbox(),
            const SizedBox(height: EffortSizes.spaceBtwSections),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.signup(),
                  child: const Text(EffortTexts.createAccount))
              )
          ],
        ));
  }
}