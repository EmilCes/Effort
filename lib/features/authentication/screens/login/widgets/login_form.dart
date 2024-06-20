import 'package:effort/features/authentication/controllers/login/login_controller.dart';
import 'package:effort/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:effort/features/authentication/screens/signup/signup.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EffortLoginForm extends StatelessWidget {
  const EffortLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
        key: controller.loginFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: EffortSizes.spaceBtwSections),
          child: Column(
            children: [
              // Email
              TextFormField(
                controller: controller.email,
                validator: (value) =>  EffortValidator.validateEmail(value),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: EffortTexts.email),
              ),
              const SizedBox(height: EffortSizes.spaceBtwInputFields),
              Obx(
                () => TextFormField(
                  controller: controller.password,
                  validator: (value) => EffortValidator.validatePassword(value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                      labelText: EffortTexts.password,
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                          onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                          icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye))),
                ),
              ),
              const SizedBox(height: EffortSizes.spaceBtwInputFields / 2),

              // Remember Me & Forget Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remember Me
                  Row(
                    children: [
                      Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value)),
                      const Text(EffortTexts.rememberMe),
                    ],
                  ),

                  // Forget Password
                  TextButton(
                      onPressed: () => Get.to(() => const ForgetPassword()),
                      child: const Text(EffortTexts.forgetPassword)),
                ],
              ),
              const SizedBox(height: EffortSizes.spaceBtwSections),

              // Sign In Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.signIn(),
                      child: const Text(EffortTexts.signIn))),

              const SizedBox(height: EffortSizes.spaceBtwItems),

              // Create Account Button
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () => Get.to(() => const SignupScreen()),
                      child: const Text(EffortTexts.createAccount))),
            ],
          ),
        ));
  }
}
