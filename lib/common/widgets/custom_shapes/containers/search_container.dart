import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/helpers/helper_functions.dart';

class EffortSearchContainer extends StatelessWidget {
  const EffortSearchContainer({
    Key? key,
    required this.text,
    required this.onTextChanged,
    required this.icon,
  }) : super(key: key);

  final String text;
  final Function(String) onTextChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final dark = EffortHelperFunctions.isDarkMode(context);

    return Container(
      width: EffortDeviceUtils.getScreenWidth(context),
      padding: const EdgeInsets.all(EffortSizes.sm),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: onTextChanged,
              decoration: InputDecoration(
                hintText: text,
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: dark ? EffortColors.grey : EffortColors.darkGrey),
                prefixIcon: Icon(icon, color: dark ? EffortColors.grey : EffortColors.darkGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
