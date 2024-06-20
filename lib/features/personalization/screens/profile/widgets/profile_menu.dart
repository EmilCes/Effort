import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EffortProfileMenu extends StatelessWidget {
  const EffortProfileMenu({
    super.key,
    this.showIcon = true,
    this.icon = Iconsax.arrow_right_34,
    required this.onPressed,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String title, value;
  final bool? showIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: EffortSizes.spaceBtwItems / 1.5),
        child: Row(
          children: [
            Expanded(flex: 3 ,child: Text(title, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
            Expanded(flex: 5, child: Text(value, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
            showIcon! ? Expanded(child: Icon(icon, size: 18)) : const Expanded(child: Text(''))
          ],
        ),
      ),
    );
  }
}