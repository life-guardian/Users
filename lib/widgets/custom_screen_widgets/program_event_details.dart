// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_app/api_urls/config.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/widgets/custom_button/custom_elevated_button.dart';
import 'package:user_app/widgets/custom_dialogs/custom_show_dialog.dart';
import 'package:user_app/widgets/custom_text_widgets/custom_text_widget.dart';
import 'package:user_app/widgets/dividers/horizontal_divider.dart';

class ProgramEventDetails extends StatelessWidget {
  const ProgramEventDetails({
    super.key,
    required this.eventName,
    required this.eventDescription,
    required this.agencyName,
    required this.eventDate,
    required this.locality,
    required this.eventId,
    required this.token,
  });

  final String eventName;
  final String eventDescription;
  final String agencyName;
  final String eventDate;
  final String locality;
  final String eventId;
  final token;

  // final void Function() registerForEvent;

  void registerForEvent(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.grey,
        ),
      ),
    );

    var reqBody = {
      "eventId": eventId,
    };

    try {
      var response = await http.put(
        Uri.parse(registerEventUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);
      var message = jsonResponse['message'];

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        Navigator.of(context).pop();
        customShowDialog(
          context: context,
          titleText: "Ooops!",
          contentText: message,
        );
      }
    } catch (e) {
      debugPrint("Registering Event Exception ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
        left: 12,
        right: 12,
        bottom: 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Events Details',
            style: GoogleFonts.mulish().copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Name'.toUpperCase(),
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    eventName,
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DESCRIPTION'.toUpperCase(),
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    eventDescription,
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 21,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TEAM NAME',
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    agencyName,
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 21,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EVENT DATE',
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yy').format(DateTime.parse(eventDate)),
                    style: GoogleFonts.plusJakartaSans().copyWith(
                      fontWeight: FontWeight.bold,
                      color: (themeData.brightness == Brightness.light)
                          ? const Color.fromARGB(255, 224, 28, 14)
                          : Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 21,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOCATION',
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    locality,
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
              const HorizontalDivider(
                thickness: 0.3,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: SizedBox(
                    width: 200,
                    height: 40,
                    child: CustomElevatedButton(
                      childWidget: const CustomTextWidget(
                        text: 'REGISTER',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        registerForEvent(context);
                      },
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
