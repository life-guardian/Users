import 'package:flutter/material.dart';
import 'package:user_app/widget/text_widget/custom_text_widget.dart';

class CustomLifeGuardianTag extends StatelessWidget {
  const CustomLifeGuardianTag({super.key, this.showLogo = true});
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CustomTextWidget(
          text: 'Life ',
          color: Colors.orange,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        const CustomTextWidget(
          text: 'Guardian',
          color: Colors.green,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
        const SizedBox(
          width: 5,
        ),
        if (showLogo)
          SizedBox(
            width: 25,
            child: Image.asset(
              'assets/images/disasterImage2.jpg',
            ),
          )
      ],
    );
  }
}
