// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/helper/services/alerts_api.dart';
import 'package:user_app/helper/services/program_and_events_api.dart';
import 'package:user_app/view/animations/listview_shimmer_effect.dart';
import 'package:user_app/helper/constants/sizes.dart';
import 'package:user_app/model/alerts.dart';
import 'package:user_app/model/nearby_events.dart';
import 'package:user_app/model/registered_events.dart';
import 'package:user_app/view_model/providers/alert_providert.dart';
import 'package:user_app/view_model/providers/device_location_provider.dart';
import 'package:user_app/view_model/providers/program_events_provider.dart';
import 'package:user_app/widget/app_bar/custom_events_appbar.dart';
import 'package:user_app/widget/screen/search_agency.dart';
import 'package:user_app/widget/listview/alerts_listview.dart';
import 'package:user_app/widget/listview/nearby_events_listview.dart';
import 'package:user_app/widget/listview/registered_events_listview.dart';

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

  AlertsApi alertsApi = AlertsApi();
  ProgramsAndEventsApi programsAndEventsApi = ProgramsAndEventsApi();

  late Widget activeWidget;
  late List<double> latLng;
  @override
  void initState() {
    super.initState();
    latLng = ref.read(deviceLocationProvider);
    if (widget.screenType == 'AlertsScreen') {
      alertShimmerAnimation();
      alertsApiCall();
    } else if (widget.screenType == 'ProgramEvents') {
      eventsShimmerAnimation();
      eventsApiCall();
    } else if (widget.screenType == 'SearchAgency') {
      activeWidget = SearchAgencyWidget(
        userName: widget.username,
        token: widget.token,
      );
    }
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

  Future<void> eventsApiCall() async {
    // get nearby events
    programsAndEventsApi
        .getNearByEventsData(
      token: widget.token,
      latitude: latLng[0],
      longitude: latLng[1],
    )
        .then((events) {
      ref.read(nearbyEventsProvider.notifier).addList(events);

      setState(() {
        activeWidget = NearbyEventsListview(
          ref: ref,
          token: widget.token,
          userName: widget.username,
        );
      });
    });
    // get registered events
    programsAndEventsApi.getRegisteredEventsData(token: widget.token).then(
      (registeredEvents) {
        ref.read(registeredEventsProvider.notifier).addList(registeredEvents);
      },
    );
  }

  void alertShimmerAnimation() {
    activeWidget = ref.read(alertsProvider).isNotEmpty
        ? AlertsListview(ref: ref)
        : const ListviewShimmerEffect();
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

    return Scaffold(
      resizeToAvoidBottomInset:
          widget.screenType == 'SearchAgency' ? false : true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomEventsAppBar(agencyName: widget.username),
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
                                        token: widget.token,
                                      );
                                    }
                                  });
                                },
                                child: Image.asset(
                                  'assets/logos/settings-sliders.png',
                                  width: 24,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (widget.screenType == 'AlertsScreen')
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "Near by Alerts. Stay Safe!",
                                style: GoogleFonts.plusJakartaSans().copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
}
