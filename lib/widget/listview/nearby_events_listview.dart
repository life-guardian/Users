// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_app/view_model/providers/program_events_provider.dart';
import 'package:user_app/view/screens/details_screen.dart';
import 'package:user_app/view/animations/transitions_animations/custom_page_transition.dart';
import 'package:user_app/widget/error/no_data_found_image.dart';

class NearbyEventsListview extends StatelessWidget {
  const NearbyEventsListview({
    super.key,
    required this.token,
    required this.ref,
    required this.userName,
  });
  final WidgetRef ref;
  final token;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final nearbyEventsList = ref.watch(nearbyEventsProvider);
    ThemeData themeData = Theme.of(context);
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: nearbyEventsList.isEmpty
          ? const NoDataFoundImage(
              headingText: "No Upcoming Events Found !",
            )
          : ListView.builder(
              itemCount: nearbyEventsList.length,
              itemBuilder: (context, index) {
                final eventData = nearbyEventsList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
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
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(88, 67, 92, 112),
                            Color.fromARGB(178, 33, 149, 243),
                          ],
                          stops: [
                            0.1,
                            0.9,
                          ],
                        ),
                      ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eventData.eventName.toString(),
                                        overflow: TextOverflow.ellipsis,
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
                                          color: const Color.fromARGB(
                                              255, 115, 115, 115),
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
                                    color: (themeData.brightness ==
                                            Brightness.light)
                                        ? const Color.fromARGB(255, 0, 58, 112)
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
                                    (themeData.brightness == Brightness.light)
                                        ? const Color.fromARGB(255, 69, 69, 69)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
