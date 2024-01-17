import 'package:flutter/material.dart';

class CustomSlideTransition extends PageRouteBuilder {
  CustomSlideTransition({
    required this.direction,
    required this.child,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );
  final Widget child;
  final AxisDirection direction;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: getBeiginOffset(),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

  Offset getBeiginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }
}
