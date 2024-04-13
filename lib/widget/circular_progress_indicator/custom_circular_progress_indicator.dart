import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
