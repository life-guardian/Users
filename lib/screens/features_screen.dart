// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/api_urls/config.dart';
import 'package:user_app/constants/sizes.dart';
import 'package:user_app/models/alerts.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/models/nearby_events.dart';
import 'package:user_app/models/registered_events.dart';
import 'package:user_app/providers/alert_providert.dart';
import 'package:user_app/providers/program_events_provider.dart';
import 'package:user_app/small_widgets/custom_screen_widgets/search_agency.dart';
import 'package:user_app/small_widgets/listview_builders/alerts_listview.dart';
import 'package:user_app/small_widgets/listview_builders/nearby_events_listview.dart';
import 'package:user_app/small_widgets/listview_builders/registered_events_listview.dart';

class FeaturesScreen extends ConsumerStatefulWidget {
  const FeaturesScreen({
    super.key,
    required this.token,
    required this.screenType,
    required this.username,
  });
  final token;
  final String screenType;
  final String username;

  @override
  ConsumerState<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends ConsumerState<FeaturesScreen> {
  List<Alerts> alertsData = [];
  List<NearbyEvents> nearbyEvents = [];
  List<RegisteredEvents> registeredEvents = [];
  String filterText = 'Upcoming Nearby Events';

  late Widget activeWidget;

  @override
  void initState() {
    super.initState();

    if (widget.screenType == 'Alerts') {
      alertsProviderActiveWidget();
      getAlertsData();
    } else if (widget.screenType == 'ProgramEvents') {
      // this is to check if provider is not empty
      nearbyEventsProviderActiveWidget();
      // this to get updated data from server
      getNearByEventsData();
      getRegisteredEventsData();
    } else if (widget.screenType == 'SearchAgency') {
      activeWidget = SearchAgencyWidget(
        userName: widget.username,
        token: widget.token,
      );
    }
  }

  void alertsProviderActiveWidget() {
    activeWidget = ref.read(alertsProvider).isNotEmpty
        ? AlertsListview(ref: ref)
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
  }

  void nearbyEventsProviderActiveWidget() {
    activeWidget = ref.read(nearbyEventsProvider).isNotEmpty
        ? NearbyEventsListview(
            token: widget.token,
            onTap: getRegisteredEventsData,
            ref: ref,
            userName: widget.username,
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
  }

  Future<void> getNearByEventsData() async {
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

    ref.read(nearbyEventsProvider.notifier).addList(data);

    setState(() {
      activeWidget = NearbyEventsListview(
        ref: ref,
        token: widget.token,
        onTap: getRegisteredEventsData,
        userName: widget.username,
      );
    });
  }

  Future<void> getRegisteredEventsData() async {
    var response = await http.get(
      Uri.parse(userRegeteredEventsUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    List<RegisteredEvents> data = [];

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      for (var jsonData in jsonResponse) {
        data.add(RegisteredEvents.fromJson(jsonData));
      }
    }

    ref.read(registeredEventsProvider.notifier).addList(data);
  }

  Future<void> getAlertsData() async {
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

    await getEventsLocality(data: data).then((alertListWithLocalities) {
      data = alertListWithLocalities;
    });

    setState(() {
      ref.read(alertsProvider.notifier).addList(data);
      activeWidget = AlertsListview(ref: ref);
    });
  }

  Future<List<Alerts>> getEventsLocality({required List<Alerts> data}) async {
    List<List<double>> coordinates = [];

    for (var event in data) {
      coordinates.add(event.alertLocation!);
    }

    List<String> localities = [];

    for (List<double> coordinate in coordinates) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(coordinate[1], coordinate[0]);
        Placemark placemark = placemarks[0];
        String? locality = placemark.locality;
        localities.add(locality!);
      } catch (error) {
        debugPrint("Error fetching locality for coordinates: $coordinate");
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
    final screenWidth = MediaQuery.of(context).size.width;
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset:
          widget.screenType == 'SearchAgency' ? false : true,
      backgroundColor: Theme.of(context).colorScheme.background,
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
                        widget.username,
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
              height: 5,
            ),
            if (widget.screenType == 'SearchAgency')
              Text(
                'Search by agency or representative name, email',
                style: GoogleFonts.rubik().copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: const Color(0xff78746D),
                ),
              ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: widget.screenType == 'SearchAgency' ? 0 : 20,
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
                                      activeWidget = RegisteredEventsListview(
                                        ref: ref,
                                        token: widget.token,
                                      );
                                      // set active widget to registered events screen here
                                    } else {
                                      filterText = 'Upcoming Nearby Events';
                                      activeWidget = NearbyEventsListview(
                                        ref: ref,
                                        userName: widget.username,
                                        onTap: getRegisteredEventsData,
                                        token: widget.token,
                                      );
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
                      Expanded(
                        child: SizedBox(
                          width: screenWidth > mobileScreenWidth
                              ? screenWidth / 1.5
                              : double.infinity,
                          child: activeWidget,
                        ),
                      ),
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
