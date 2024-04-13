import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.childWidget,
    this.color = const Color(0xff2F80ED),
    required this.onPressed,
    this.onPressedEnabled = true,
    this.backgroundColor,
  });
  final Widget childWidget;
  final void Function() onPressed;
  final Color color;
  final bool onPressedEnabled;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressedEnabled ? onPressed : () {},
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(200, 40),
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.tertiary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: childWidget,
      ),
    );
  }
}
