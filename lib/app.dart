import 'package:effort/bindings/general_bindings.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: EffortAppTheme.lightTheme,
      darkTheme: EffortAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      // Show loader meanwhile Authentication Repository is deciding to show screen
      home: const Scaffold(backgroundColor: EffortColors.primary, body: Center(child: CircularProgressIndicator(color: Colors.white)))
    );
  }
}