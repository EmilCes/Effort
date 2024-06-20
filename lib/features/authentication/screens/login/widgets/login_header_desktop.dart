import 'package:effort/utils/constants/image_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EffortLoginHeaderDesktop extends StatelessWidget {

  const EffortLoginHeaderDesktop({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final dark = EffortHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
            height: 200,
            width: 200,
            alignment: Alignment.centerLeft,
            image: AssetImage(dark ? EffortImages.darkAppLogoSm : EffortImages.lightAppLogoSm)
        )
      ],
    );
  }
}