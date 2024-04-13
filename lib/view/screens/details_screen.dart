// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/helper/constants/api_keys.dart';
import 'package:user_app/widget/app_bar/custom_events_appbar.dart';
import 'package:user_app/widget/screen/agency_details.dart';
import 'package:user_app/widget/screen/program_event_details.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.eventId,
    required this.token,
    required this.screenType,
    required this.userName,
  });

  final String eventId;
  final String screenType;
  final token;
  final String userName;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Widget activeScreen = const Center(
    child: CircularProgressIndicator(
      color: Colors.grey,
    ),
  );

  bool isLoading = true;

  String? eventName;
  String? eventId;
  String? eventDescription;
  String? eventDate;
  String? agencyName;
  String? agencyEmail;
  String? representativeName;
  String? agencyAddress;
  int? rescueOperations;
  int? eventsOrganized;
  int? agencyPhone;
  List<double>? coordinate;
  String? locality;

  @override
  void initState() {
    super.initState();
    if (widget.screenType == 'EventDetails') {
      getEventsDetails();
    } else if (widget.screenType == 'AgencyDetails') {
      getAgencyDetails();
    }
  }

  void getAgencyDetails() async {
    try {
      var response = await http.get(
        Uri.parse('$agencyDetailsUrl/${widget.eventId.toString()}'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        agencyName = jsonResponse['agencyName'];
        agencyEmail = jsonResponse['agencyEmail'];
        representativeName = jsonResponse['representativeName'];
        agencyAddress = jsonResponse['agencyAddress'];
        rescueOperations = jsonResponse['rescueOperations'];
        eventsOrganized = jsonResponse['eventsOrganized'];
        agencyPhone = jsonResponse['agencyPhone'];
      }

      activeScreen = AgencyDetails(
          agencyName: agencyName!,
          agencyEmail: agencyEmail!,
          representativeName: representativeName!,
          agencyAddress: agencyAddress!,
          rescueOperations: rescueOperations!,
          eventsOrganized: eventsOrganized!,
          agencyPhone: agencyPhone!);
    } catch (e) {
      debugPrint('Exception ocurred while fetchin getAgencyDetails');
    }
    setState(() {
      isLoading = false;
    });
  }

  void getEventsDetails() async {
    try {
      var response = await http.get(
        Uri.parse('$eventDetailsUrl/${widget.eventId.toString()}'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        eventName = jsonResponse['eventName'];
        eventId = jsonResponse['eventId'];
        eventDescription = jsonResponse['eventDescription'];
        agencyName = jsonResponse['agencyName'];
        eventDate = jsonResponse['eventDate'];
        coordinate = jsonResponse['eventLocation'].cast<double>();

        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(coordinate![1], coordinate![0]);
          Placemark placemark = placemarks[0];
          locality = placemark.locality;
        } catch (error) {
          debugPrint("Error fetching locality for coordinates: $coordinate");
        }

        activeScreen = ProgramEventDetails(
          eventName: eventName!,
          eventDescription: eventDescription!,
          agencyName: agencyName!,
          eventDate: eventDate!,
          locality: locality!,
          eventId: eventId!,
          token: widget.token,
          
          // registerForEvent: registerForEvent,
        );
      }
    } catch (e) {
      debugPrint('Exception ocurred while fetching getAgencyDetails');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomEventsAppBar(agencyName: widget.userName),
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
                SizedBox(
                  height: isLoading ? screenHeight / 3 : 11,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isLoading
                        ? null
                        : Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: activeScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
