import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:effort/utils/constants/colors.dart';

class EffortPopupMenuButton extends StatelessWidget {
  final PopupMenuItemSelected<String> onSelected;
  final PopupMenuItemBuilder<String> itemBuilder;
  final IconData iconData;

  const EffortPopupMenuButton({
    Key? key,
    required this.onSelected,
    required this.itemBuilder, required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = EffortHelperFunctions.isDarkMode(context);

    return PopupMenuButton<String>(
      color: dark ? EffortColors.darkBackground : EffortColors.white,
      surfaceTintColor: dark ? EffortColors.dark : EffortColors.white,
      icon: Icon(iconData),
      onSelected: onSelected,
      itemBuilder: itemBuilder,
    );
  }
}
