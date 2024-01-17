// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/api_urls/config.dart';
import 'package:user_app/models/alerts.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/models/nearby_events.dart';
import 'package:user_app/small_widgets/listview_builders/alerts_listview.dart';
import 'package:user_app/small_widgets/listview_builders/nearby_events_listview.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({
    super.key,
    required this.token,
    required this.screenType,
  });
  final token;
  final String screenType;

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  List<Alerts> alertsData = [];
  List<NearbyEvents> nearbyEvents = [];
  String filterText = 'Upcoming Nearby Events';

  Widget activeWidget = const Center(
    child: CircularProgressIndicator(
      color: Colors.grey,
    ),
  );

  @override
  void initState() {
    super.initState();
    if (widget.screenType == 'Alerts') {
      getAlertsData().then((value) => {
            setState(() {
              alertsData.addAll(value);
              activeWidget = AlertsListview(list: alertsData);
            })
          });
    } else if (widget.screenType == 'ProgramEvents') {
      getNearByEventsData().then((value) => {
            setState(() {
              nearbyEvents.addAll(value);
              activeWidget = NearbyEventsListview(
                list: nearbyEvents,
                token: widget.token,
              );
            })
          });
    } else {}
  }

  Future<List<NearbyEvents>> getNearByEventsData() async {
    var response = await http.get(
      Uri.parse(nearbyEventsUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    List<NearbyEvents> data = [];

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      for (var jsonData in jsonResponse) {
        data.add(NearbyEvents.fromJson(jsonData));
      }
    }

    return data;
  }

  Future<List<Alerts>> getAlertsData() async {
    var response = await http.get(
      Uri.parse(alertUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    List<Alerts> data = [];

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      for (var jsonData in jsonResponse) {
        data.add(Alerts.fromJson(jsonData));
      }
    }

    return getEventsLocality(data: data);
  }

  Future<List<Alerts>> getEventsLocality({required List<Alerts> data}) async {
    List<List<double>> coordinates = [];

    for (var event in data) {
      coordinates.add(event.alertLocation!);
    }

    // print(coordinates.toList());

    List<String> localities = [];

    for (List<double> coordinate in coordinates) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(coordinate[1], coordinate[0]);
        Placemark placemark = placemarks[0];
        String? locality = placemark.locality;
        localities.add(locality!);
      } catch (error) {
        print("Error fetching locality for coordinates: $coordinate");
        localities.add("Unknown"); // Add a placeholder for unknown localities
      }
    }

    for (int i = 0; i < data.length; i++) {
      data[i].locality = localities[i];
    }

    return data;
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
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(240, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 15,
                    right: 15,
                    bottom: 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.screenType == 'ProgramEvents')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                filterText,
                                style: GoogleFonts.plusJakartaSans().copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (filterText ==
                                        'Upcoming Nearby Events') {
                                      filterText = 'Registered Events';
                                    } else {
                                      filterText = 'Upcoming Nearby Events';
                                    }
                                  });
                                },
                                child: Image.asset(
                                  'assets/logos/settings-sliders.png',
                                  width: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 21,
                      ),
                      Expanded(child: activeWidget),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
