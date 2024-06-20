import 'package:effort/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(EffortSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Headings
              Text(EffortTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: EffortSizes.spaceBtwItems),
              Text(EffortTexts.forgetPasswordSubtitle, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: EffortSizes.spaceBtwSections * 2),

              // Text Fields
              TextFormField(
                decoration: const InputDecoration(
                  labelText: EffortTexts.email,
                  prefixIcon: Icon(Iconsax.direct_right)
                ),
              ),
              const SizedBox(height: EffortSizes.spaceBtwSections),

              // Submit Buttons
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () => Get.off(() => const ResetPassword()), child: const Text(EffortTexts.submit))
              )
            ],
          ),
      ),
    );
  }
}
