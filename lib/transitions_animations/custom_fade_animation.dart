import 'package:flutter/material.dart';

class CustomFadeTransition extends PageRouteBuilder {
  CustomFadeTransition({
    required this.child,
    required this.durationMiliseconds,
  }) : super(
          transitionDuration: Duration(
            milliseconds: durationMiliseconds,
          ),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );
  final Widget child;
  final int durationMiliseconds;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FadeTransition(
        opacity: animation,
        child: child,
      );
}
