// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:user_app/helper/constants/api_keys.dart';
import 'package:user_app/helper/services/alerts_api.dart';
import 'package:user_app/view/animations/listview_shimmer_effect.dart';
import 'package:user_app/helper/constants/sizes.dart';
import 'package:user_app/model/alerts.dart';
import 'package:user_app/view_model/providers/alert_providert.dart';
import 'package:user_app/view_model/providers/device_location_provider.dart';
import 'package:user_app/widget/app_bar/custom_events_appbar.dart';
import 'package:user_app/widget/custom_%20textfields/custom_textfield.dart';
import 'package:user_app/widget/dialogs/osm_map_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/widget/listview/alerts_listview.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({
    super.key,
    required this.token,
    required this.username,
  });
  final token;
  final String username;

  @override
  ConsumerState<AlertsScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends ConsumerState<AlertsScreen> {
  List<Alerts> alertsData = [];
  int pageIndex = 1;
  bool isSearchExpanded = false;
  AlertsApi alertsApi = AlertsApi();
  late Widget activeWidget;
  late List<double> latLng;
  List<double> searchLocationCoordinates = [0, 0];

  @override
  void initState() {
    super.initState();
    latLng = ref.read(deviceLocationProvider);
    shimmerAnimation();
    alertsApiCall();
  }

  Future<void> alertsApiCall() async {
    alertsApi
        .getNearByAlerts(
      token: widget.token,
      latitude: latLng[0],
      longitude: latLng[1],
    )
        .then((alerts) {
      setState(() {
        ref.read(alertsProvider.notifier).addList(alerts);
        activeWidget = AlertsListview(ref: ref);
      });
    });
  }

  void shimmerAnimation() {
    activeWidget = ref.read(alertsProvider).isNotEmpty
        ? AlertsListview(ref: ref)
        : const ListviewShimmerEffect(
            cardHeight: 120,
          );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomEventsAppBar(agencyName: widget.username),
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
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 15,
                    right: 15,
                    bottom: 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Near by Alerts. Stay Safe!",
                              style: GoogleFonts.plusJakartaSans().copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton<String>(
                              underline: const SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (newValue == 'Search') {
                                    isSearchExpanded =
                                        isSearchExpanded ? false : true;
                                  } else if (newValue == 'Pick Location') {
                                    isSearchExpanded = false;
                                    pickLocationFromMap();
                                  }
                                });
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              icon: const Icon(Icons.more_vert_rounded),
                              style: GoogleFonts.mulish(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              items: <String>[
                                'Clear All',
                                'Search',
                                'Pick Location'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      if (isSearchExpanded)
                        ZoomIn(
                          duration: const Duration(milliseconds: 500),
                          animate: true,
                          child: CustomTextfield(
                            onChanged: (value) {
                              searchByAlertName(
                                searchText: value,
                              ).then((serachedAlerts) {
                                setState(() {
                                  ref
                                      .read(alertsProvider.notifier)
                                      .addList(serachedAlerts);
                                  activeWidget = AlertsListview(ref: ref);
                                });
                              });
                            },
                            hintText: "Search by alert name",
                          ),
                        ),
                      const SizedBox(
                        height: 11,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: screenWidth > mobileScreenWidth
                              ? screenWidth / 1.5
                              : double.infinity,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 500),
                            child: activeWidget,
                          ),
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

  Future<List<Alerts>> searchByAlertName({required String searchText}) async {
    List<double> tempLatLng = [latLng[0], latLng[1]];
    var response = await http.get(
      Uri.parse(
          "$baseUrl/api/alert/search/?page=$pageIndex&limit=30&lat=${tempLatLng[0]}&lng=${tempLatLng[1]}&searchText=$searchText"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    List<Alerts> data = [];
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      for (var jsonData in jsonResponse) {
        data.add(Alerts.fromJson(jsonData));
      }
    }

    await alertsApi
        .getEventsLocality(data: data)
        .then((alertListWithLocalities) {
      data = alertListWithLocalities;
    });

    return data;
  }

  Future<void> pickLocationFromMap() async {
    PickedData pickedLocationData = await osmMapDialog(
        context: context, titleText: 'Select Location to send alert');
    searchLocationCoordinates[0] = pickedLocationData.latLong.latitude;
    searchLocationCoordinates[1] = pickedLocationData.latLong.longitude;

    debugPrint(
        "Search picked location from osm map is lat: ${searchLocationCoordinates[0]} , lng: ${searchLocationCoordinates[1]}");
  }
}
