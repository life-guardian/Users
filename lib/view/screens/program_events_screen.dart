import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:user_app/helper/services/program_and_events_api.dart';
import 'package:user_app/view/animations/listview_shimmer_effect.dart';
import 'package:user_app/helper/constants/sizes.dart';
import 'package:user_app/model/nearby_events.dart';
import 'package:user_app/model/registered_events.dart';
import 'package:user_app/view_model/providers/device_location_provider.dart';
import 'package:user_app/view_model/providers/program_events_provider.dart';
import 'package:user_app/view_model/providers/user_details_provider.dart';
import 'package:user_app/widget/app_bar/custom_events_appbar.dart';
import 'package:user_app/widget/custom_%20textfields/custom_textfield.dart';
import 'package:user_app/widget/dialogs/osm_map_dialog.dart';
import 'package:user_app/widget/listview/nearby_events_listview.dart';
import 'package:user_app/widget/listview/registered_events_listview.dart';

class ProgramEventsScreen extends ConsumerStatefulWidget {
  const ProgramEventsScreen({
    super.key,
    required this.token,
    required this.username,
  });

  final String token;
  final String username;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProgramEventsScreenState();
}

class _ProgramEventsScreenState extends ConsumerState<ProgramEventsScreen> {
  List<NearbyEvents> nearbyEvents = [];
  List<RegisteredEvents> registeredEvents = [];
  int _currentIndx = 0;
  String filterText = 'Upcoming Nearby Events';
  ProgramsAndEventsApi programsAndEventsApi = ProgramsAndEventsApi();
  late Widget activeWidget;
  late List<double> latLng;
  bool isSearchExpanded = false;
  List<double> searchLocationCoordinates = [0, 0];
  bool isSearchOptionAvailable = true;

  @override
  void initState() {
    super.initState();
    latLng = ref.read(deviceLocationProvider);
    eventsApiCall();
  }

  Future<void> eventsApiCall() async {
    eventsShimmerAnimation();
    programsAndEventsApi
        .getNearByEventsData(
      token: widget.token,
      latitude: latLng[0],
      longitude: latLng[1],
    )
        .then((events) {
      ref.read(nearbyEventsProvider.notifier).addList(events);
      ref.read(isNearbyEventsLoading.notifier).state = false;

      setState(() {
        activeWidget = NearbyEventsListview(
          ref: ref,
          token: widget.token,
          userName: widget.username,
        );
      });
    });

    programsAndEventsApi.getRegisteredEventsData(token: widget.token).then(
      (registeredEvents) {
        ref.read(registeredEventsProvider.notifier).addList(registeredEvents);
      },
    );
  }

  void eventsShimmerAnimation() {
    activeWidget = ref.read(nearbyEventsProvider).isNotEmpty
        ? NearbyEventsListview(
            token: widget.token,
            ref: ref,
            userName: widget.username,
          )
        : const ListviewShimmerEffect();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isEventsLoading = ref.watch(isNearbyEventsLoading);

    if (!isEventsLoading) {
      if (_currentIndx == 0) {
        filterText = 'Upcoming Nearby Events';
        isSearchOptionAvailable = true;
        activeWidget = NearbyEventsListview(
          ref: ref,
          userName: widget.username,
          token: widget.token,
        );
      } else {
        filterText = 'Registered Events';
        isSearchOptionAvailable = false;
        activeWidget = RegisteredEventsListview(
          ref: ref,
          token: widget.token,
        );
      }
    }

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
                            if (isSearchOptionAvailable)
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
                                    } else {
                                      isSearchExpanded = false;
                                    }
                                  });
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                icon: const Icon(Icons.more_vert_rounded),
                                style: GoogleFonts.mulish(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                items: <String>[
                                  'Pick Location',
                                  'Search',
                                  'Reset',
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
                      if (isSearchExpanded && _currentIndx == 0)
                        ZoomIn(
                          duration: const Duration(milliseconds: 500),
                          animate: true,
                          child: CustomTextfield(
                            onChanged: (value) {
                              searchByEventtName(
                                searchText: value,
                              ).then((serachedAlerts) {
                                setState(() {
                                  // ref.read(alertsProvider.notifier).state = [];
                                  // activeWidget = AlertsListview(ref: ref);
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
      bottomNavigationBar: Container(
        // alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            unselectedItemColor: const Color.fromARGB(175, 158, 158, 158),
            currentIndex: _currentIndx,
            iconSize: 25,
            onTap: (value) {
              setState(() {
                _currentIndx = value;
              });
            },
            elevation: 5,
            selectedItemColor: activeIconColor(),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.event_rounded),
                activeIcon: Icon(Icons.event_rounded),
                label: 'Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_available_outlined),
                activeIcon: Icon(Icons.event_available_outlined),
                label: 'Registered Events',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> searchByEventtName({required String searchText}) async {
    // var response = await http.get(
    //   Uri.parse(
    //       "$baseUrl/api/event/search/?page=1&limit=30&searchText=k&lng=&lat="),
    //   headers: {
    //     "Content-Type": "application/json",
    //     'Authorization': 'Bearer ${widget.token}'
    //   },
    // );

    // List<Alerts> data = [];
    // if (response.statusCode == 200) {
    //   final jsonResponse = jsonDecode(response.body);
    //   for (var jsonData in jsonResponse) {
    //     data.add(Alerts.fromJson(jsonData));
    //   }
    // }

    // await alertsApi
    //     .getEventsLocality(data: data)
    //     .then((alertListWithLocalities) {
    //   data = alertListWithLocalities;
    // });

    // return data;
  }

  Future<void> pickLocationFromMap() async {
    PickedData pickedLocationData = await osmMapDialog(
        context: context, titleText: 'Select Location to send alert');
    searchLocationCoordinates[0] = pickedLocationData.latLong.latitude;
    searchLocationCoordinates[1] = pickedLocationData.latLong.longitude;

    debugPrint(
        "Search picked location from osm map is lat: ${searchLocationCoordinates[0]} , lng: ${searchLocationCoordinates[1]}");
  }

  Color activeIconColor() {
    if (_currentIndx == 0) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}
