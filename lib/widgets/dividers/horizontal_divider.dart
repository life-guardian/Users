import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({
    super.key,
    this.color = Colors.grey,
    this.thickness = 0.3,
    this.indent,
    this.endIndent,
  });
  final Color? color;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: indent,
      color: color,
      thickness: thickness,
      endIndent: endIndent,
    );
  }
}
