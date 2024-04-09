import 'package:flutter/material.dart';
import 'package:user_app/widgets/custom_text_widgets/custom_text_widget.dart';

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
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // stops: [0.1, 0.8],
          colors: [color1, color2],
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
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
    );
  }
}
