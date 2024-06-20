import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class EffortAnimationLoaderWidget extends StatelessWidget {

  const EffortAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed
  });

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(  // Envolvemos el contenido en un SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(animation, width: MediaQuery.of(context).size.width * 0.8,),
            const SizedBox(height: EffortSizes.defaultSpace),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: EffortSizes.defaultSpace),
            showAction
                ? SizedBox(
              width: 250,
              child: OutlinedButton(
                onPressed: onActionPressed,
                style: OutlinedButton.styleFrom(backgroundColor: EffortColors.black),
                child: Text(
                  actionText!,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(color: EffortColors.light),
                ),
              ),
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
