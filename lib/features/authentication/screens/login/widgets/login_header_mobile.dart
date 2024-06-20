import 'package:effort/utils/constants/image_strings.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:effort/utils/constants/text_strings.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EffortLoginHeaderMobile extends StatelessWidget {

  const EffortLoginHeaderMobile({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final dark = EffortHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
            height: 150,
            width: 150,
            alignment: Alignment.centerLeft,
            image: AssetImage(dark ? EffortImages.darkAppLogoSm : EffortImages.lightAppLogoSm)
        ),
        Text(EffortTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium,),
        const SizedBox(height: EffortSizes.sm),
        Text(EffortTexts.loginSubtitle, style: Theme.of(context).textTheme.bodyMedium,),
      ],
    );
  }
}