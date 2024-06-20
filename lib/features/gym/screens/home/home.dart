import 'package:effort/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            EffortPrimaryHeaderContainer(
              child: Column(
                children: [
                  EffortHomeAppBar(),
                  SizedBox(height: EffortSizes.spaceBtwSections)
                ],
              )
              ),
          ],
        ),
      ),
    );
  }
}

