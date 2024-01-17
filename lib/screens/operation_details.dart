// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/api_urls/config.dart';
import 'package:user_app/small_widgets/custom_dialogs/custom_show_dialog.dart';
import 'package:user_app/small_widgets/custom_screen_widgets/operation_details_widget.dart';

class OperationDetailsScreen extends StatefulWidget {
  const OperationDetailsScreen({
    super.key,
    required this.eventId,
    required this.token,
  });

  final String eventId;
  final token;

  @override
  State<OperationDetailsScreen> createState() => _OperationDetailsScreenState();
}

class _OperationDetailsScreenState extends State<OperationDetailsScreen> {
  Widget activeScreen = const Center(
    child: CircularProgressIndicator(
      color: Colors.grey,
    ),
  );

  late String eventName;
  late String eventId;
  late String eventDescription;
  late String agencyName;
  late String eventDate;
  late List<double> coordinate;
  String? locality;

  @override
  void initState() {
    super.initState();
    getOperationDetailsData();
  }

  void getOperationDetailsData() async {
    var response = await http.get(
      Uri.parse('$eventDetailsUrl/${widget.eventId.toString()}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    var jsonResponse = jsonDecode(response.body);

    eventName = jsonResponse['eventName'];
    eventId = jsonResponse['eventId'];
    eventDescription = jsonResponse['eventDescription'];
    agencyName = jsonResponse['agencyName'];
    eventDate = jsonResponse['eventDate'];
    coordinate = jsonResponse['eventLocation'].cast<double>();

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(coordinate[1], coordinate[0]);
      Placemark placemark = placemarks[0];
      locality = placemark.locality;
      print(locality);
    } catch (error) {
      print("Error fetching locality for coordinates: $coordinate");
    }

    activeScreen = OperationDetailsWidget(
      eventName: eventName,
      eventDescription: eventDescription,
      agencyName: agencyName,
      eventDate: eventDate,
      locality: locality!,
      eventId: eventId,
      token: widget.token,
      // registerForEvent: registerForEvent,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/logos/indiaflaglogo.png'),
                  const SizedBox(
                    width: 21,
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jai Hind!',
                        style: GoogleFonts.inter().copyWith(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'userName',
                        // email,
                        style: GoogleFonts.plusJakartaSans().copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      foregroundColor:
                          (themeData.brightness == Brightness.light)
                              ? const Color.fromARGB(185, 30, 35, 44)
                              : const Color(0xffe1dcd3),
                      side: BorderSide(
                        color: (themeData.brightness == Brightness.light)
                            ? const Color.fromARGB(32, 30, 35, 44)
                            : const Color(0xffE1DCD3),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                        Text('back')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 11,
            ),
            Image.asset('assets/images/disasterImage2.jpg'),
            Text(
              'Life Guardian',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w900,
                fontSize: 30,
                shadows: const [
                  Shadow(
                    offset: Offset(0.0, 7.0),
                    blurRadius: 15.0,
                    color: Color.fromARGB(57, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 11,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(240, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: activeScreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
