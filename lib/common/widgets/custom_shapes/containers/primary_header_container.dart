import 'package:effort/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:effort/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class EffortPrimaryHeaderContainer extends StatelessWidget {
  const EffortPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EffortCurvedEdgeWidget(
      child: Container(
        color: EffortColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(top: -150, right: -250, child: EffortCircularContainer(backgroundColor: EffortColors.textWhite.withOpacity(0.1))),
            Positioned(top: 100, right: -300, child: EffortCircularContainer(backgroundColor: EffortColors.textWhite.withOpacity(0.1))),
            child
          ],
        ),
      ),
    );
  }
}

