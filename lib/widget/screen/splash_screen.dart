import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:user_app/widget/text_widget/custom_liefguardian_tag.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Image.asset(
                  'assets/images/disasterImage1.png',
                  width: screenWidth / 1.5,
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomLifeGuardianTag(
                  showLogo: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
