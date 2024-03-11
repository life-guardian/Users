// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_app/models/nearby_events.dart';
import 'package:user_app/providers/program_events_provider.dart';
import 'package:user_app/screens/details_screen.dart';
import 'package:user_app/transitions_animations/custom_page_transition.dart';

class NearbyEventsListview extends StatelessWidget {
  const NearbyEventsListview({
    super.key,
    required this.token,
    required this.ref,
    required this.userName,
    required this.onTap,
  });
  final WidgetRef ref;
  final token;
  final String userName;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final nearbyEventsList = ref.watch(nearbyEventsProvider);
    ThemeData themeData = Theme.of(context);
    return nearbyEventsList.isEmpty
        ? Center(
            child: Text(
              'No data found, Sorry! 😔',
              style: GoogleFonts.plusJakartaSans().copyWith(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemCount: nearbyEventsList.length,
            itemBuilder: (context, index) {
              final eventData = nearbyEventsList[index];
              return GestureDetector(
                onTap: () async {
                  final isRecallNearbyEvents = await Navigator.of(context).push(
                    CustomSlideTransition(
                      direction: AxisDirection.left,
                      child: DetailsScreen(
                        userName: userName,
                        eventId: eventData.eventId.toString(),
                        token: token,
                        screenType: 'EventDetails',
                      ),
                    ),
                  );

                  if (isRecallNearbyEvents) {
                    onTap();
                  }
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eventData.eventName.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        GoogleFonts.plusJakartaSans().copyWith(
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
                                    style:
                                        GoogleFonts.plusJakartaSans().copyWith(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 11,
                            ),
                            Text(
                              DateFormat('dd/MM/yy').format(DateTime.parse(
                                  eventData.eventDate.toString())),
                              style: GoogleFonts.plusJakartaSans().copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    (themeData.brightness == Brightness.light)
                                        ? const Color.fromARGB(255, 224, 28, 14)
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
                            color: const Color.fromARGB(255, 128, 127, 127),
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
}
