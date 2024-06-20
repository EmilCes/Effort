import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/theme/custom_themes/appbar_theme.dart';
import 'package:effort/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:effort/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:effort/utils/theme/custom_themes/chip_theme.dart';
import 'package:effort/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:effort/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:effort/utils/theme/custom_themes/text_field_theme.dart';
import 'package:effort/utils/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class EffortAppTheme {

  EffortAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    //fontFamily: 'Name',
    brightness: Brightness.light,
    primaryColor: EffortColors.primary,
    textTheme: EffortTextTheme.lightTextTheme,
    chipTheme: EffortChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: EffortAppBarTheme.lightAppBarTheme,
    checkboxTheme: EffortCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: EffortBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: EffortElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: EffortOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: EffortTextFormFieldTheme.lightInputDecorationTheme
  );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      //fontFamily: 'Name',
      brightness: Brightness.dark,
      primaryColor: EffortColors.primary,
      textTheme: EffortTextTheme.darkTextTheme,
      chipTheme: EffortChipTheme.darkChipTheme,
      scaffoldBackgroundColor: EffortColors.darkBackground,
      appBarTheme: EffortAppBarTheme.darkAppBarTheme,
      checkboxTheme: EffortCheckboxTheme.darkCheckboxTheme,
      bottomSheetTheme: EffortBottomSheetTheme.darkBottomSheetTheme,
      elevatedButtonTheme: EffortElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: EffortOutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: EffortTextFormFieldTheme.darkInputDecorationTheme

  );


}