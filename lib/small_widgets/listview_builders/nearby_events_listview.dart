// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_app/models/nearby_events.dart';
import 'package:user_app/screens/operation_details.dart';
import 'package:user_app/transitions_animations/custom_page_transition.dart';

class NearbyEventsListview extends StatelessWidget {
  const NearbyEventsListview({
    super.key,
    required this.list,
    required this.token,
    required this.stream,
  });
  final List<NearbyEvents> list;
  final token;
  final Stream stream;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return list.isEmpty
        ? Center(
            child: Text(
              'No data found, Sorry! 😔',
              style: GoogleFonts.plusJakartaSans().copyWith(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          )
        : StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final snapshotData = snapshot.data!;
                return ListView.builder(
                  itemCount: snapshotData.length,
                  itemBuilder: (context, index) {
                    final eventData = snapshotData[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CustomSlideTransition(
                            direction: AxisDirection.left,
                            child: OperationDetailsScreen(
                              eventId: eventData.eventId.toString(),
                              token: token,
                              screenType: 'OperationDetails',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Theme.of(context).colorScheme.secondary,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 20,
                            bottom: 5,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eventData.eventName.toString(),
                                        style: GoogleFonts.plusJakartaSans()
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        eventData.agencyName!
                                            .toUpperCase()
                                            .toString(),
                                        style: GoogleFonts.plusJakartaSans()
                                            .copyWith(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yy').format(
                                        DateTime.parse(
                                            eventData.eventDate.toString())),
                                    style:
                                        GoogleFonts.plusJakartaSans().copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: (themeData.brightness ==
                                              Brightness.light)
                                          ? const Color.fromARGB(
                                              255, 224, 28, 14)
                                          : Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 11,
                              ),
                              Text(
                                'Tap to Register'.toUpperCase(),
                                style: GoogleFonts.plusJakartaSans().copyWith(
                                  color:
                                      const Color.fromARGB(255, 128, 127, 127),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            },
          );
  }
}
