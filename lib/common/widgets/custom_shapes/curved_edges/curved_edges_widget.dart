import 'package:effort/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:flutter/material.dart';

class EffortCurvedEdgeWidget extends StatelessWidget {
  const EffortCurvedEdgeWidget({
    super.key, this.child,
  });

  final Widget? child;


  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: EffortCustomCurvedEdges(),
        child: child
    );
  }
}