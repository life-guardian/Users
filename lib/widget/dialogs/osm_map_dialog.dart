import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:user_app/widget/maps/open_street_map.dart';

Future osmMapDialog({
  required BuildContext context,
  String? titleText,
}) =>
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: const OpenStreetMap(),
        ),
      ),
    );
