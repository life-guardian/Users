import 'package:flutter/material.dart';
import 'package:user_app/widget/buttons/custom_back_button.dart';
import 'package:user_app/widget/text_widget/custom_text_widget.dart';

class CustomEventsAppBar extends StatelessWidget {
  const CustomEventsAppBar({
    super.key,
    required this.agencyName,
  });

  final String agencyName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/logos/indiaflaglogo.png'),
          const SizedBox(
            width: 21,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomTextWidget(
                  text: 'Jai Hind!',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextWidget(
                  text: agencyName,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  // maxLines: 3,
                  // textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const CustomBackButton(
            text: "back",
          ),
        ],
      ),
    );
  }
}
