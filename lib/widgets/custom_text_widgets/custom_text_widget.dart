import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({
    super.key,
    required this.text,
    this.fontSize = 12,
    this.fontWeight = FontWeight.bold,
    this.color,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // overflow: TextOverflow.ellipsis,
      style: GoogleFonts.mulish(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color ?? Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}
