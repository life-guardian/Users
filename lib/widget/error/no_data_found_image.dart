import 'package:flutter/material.dart';
import 'package:user_app/widget/text_widget/custom_text_widget.dart';

class NoDataFoundImage extends StatelessWidget {
  const NoDataFoundImage({super.key, this.headingText});
  final String? headingText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            child: Image.asset(
              "assets/images/animated_images/nothingfound.png",
            ),
          ),
          CustomTextWidget(
            text: headingText ?? "",
            fontSize: 14,
            fontWeight: FontWeight.normal,
          )
        ],
      ),
    );
  }
}
