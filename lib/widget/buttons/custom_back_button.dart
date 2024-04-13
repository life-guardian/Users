import 'package:flutter/material.dart';
import 'package:user_app/widget/text_widget/custom_text_widget.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.text,
    this.outlinedColor,
  });

  final String? text;
  final Color? outlinedColor;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: outlinedColor ??
            ((themeData.brightness == Brightness.light)
                ? const Color.fromARGB(185, 30, 35, 44)
                : const Color(0xffe1dcd3)),
        side: BorderSide(
          color: outlinedColor ??
              ((themeData.brightness == Brightness.light)
                  ? const Color.fromARGB(32, 30, 35, 44)
                  : const Color(0xffE1DCD3)),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          if (text != null)
            CustomTextWidget(
              text: text!,
              color: outlinedColor,
            )
        ],
      ),
    );
  }
}
