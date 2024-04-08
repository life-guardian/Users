import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future customLogoutDialog(
        {required BuildContext context,
        required String titleText,
        required Function() onTap,
        Color actionButton1Color = Colors.blue,
        Color actionButton2Color = Colors.red,
        required String actionText2,
        required String contentText}) =>
    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: const Color.fromARGB(155, 0, 0, 0),
      builder: (context) => FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: AlertDialog(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
            titleText,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          content: RichText(
            text: TextSpan(
              text: contentText,
              style: GoogleFonts.lato(
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.mulish(color: actionButton1Color),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: onTap,
                child: Text(
                  actionText2,
                  style: GoogleFonts.mulish(color: actionButton2Color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
