import 'package:flutter/material.dart';
import 'package:user_app/widget/text_widget/custom_text_widget.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.width,
    required this.height,
    required this.color1,
    required this.color2,
    required this.title,
    required this.desc,
  });

  final double width;
  final double height;
  final Color color1;
  final Color color2;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Card(
      elevation: 3,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: (themeData.brightness == Brightness.dark)
              ? Theme.of(context).colorScheme.tertiary
              : null,
          gradient: (themeData.brightness == Brightness.light)
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // stops: [0.1, 0.8],
                  colors: [color1, color2],
                )
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextWidget(
                text: title,
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextWidget(
                text: desc,
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
