import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/animation_loader.dart';

class EffortFullScreenLoader {
  static bool _isDialogOpen = false;

  static void openLoadingDialog(String text, String animation) {
    if (!_isDialogOpen) {
      _isDialogOpen = true;
      Get.dialog(
        PopScope(
          canPop: false,
          child: Container(
            color: EffortHelperFunctions.isDarkMode(Get.context!)
                ? EffortColors.dark
                : EffortColors.white,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(  // Utiliza Expanded para ajustar el contenido
                    child: EffortAnimationLoaderWidget(text: text, animation: animation)
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void stopLoading() {
    if (_isDialogOpen) {
      _isDialogOpen = false;
      Get.back();
    }
  }
}
