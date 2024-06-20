import 'dart:io' show Platform;

import 'package:effort/common/styles/spacing_styles.dart';
import 'package:effort/features/authentication/screens/login/widgets/login_header_desktop.dart';
import 'package:flutter/material.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header_mobile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Platform.isWindows || Platform.isMacOS || Platform.isLinux
          ? buildDesktopLayout()
          : buildMobileLayout(),
    );
  }

  Widget buildMobileLayout() {
    return const SingleChildScrollView(
      child: Padding(
        padding: EffortSpacingStyle.paddingWithAppBarHeight,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo, Title & Subtitle
              EffortLoginHeaderMobile(),

              // Form
              EffortLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDesktopLayout() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EffortLoginHeaderDesktop(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0)
                ),
                SizedBox(height: 10.0),
                EffortLoginForm(),
              ],
            ),
          ),
        ),
      ],
    );
  }


}
