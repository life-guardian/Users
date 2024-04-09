// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_app/providers/program_events_provider.dart';
import 'package:user_app/widgets/custom_images/no_data_found_image.dart';

class RegisteredEventsListview extends StatelessWidget {
  const RegisteredEventsListview({
    super.key,
    required this.ref,
    required this.token,
  });

  final token;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final registeredEventsList = ref.watch(registeredEventsProvider);
    return registeredEventsList.isEmpty
        ? const NoDataFoundImage(
            headingText: "No Registered Events !",
          )
        : ListView.builder(
            itemCount: registeredEventsList.length,
            itemBuilder: (context, index) {
              final eventData = registeredEventsList.elementAt(index);
              return SizedBox(
                height: 90,
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
                          Color.fromARGB(69, 57, 111, 59),
                          Color.fromARGB(169, 20, 191, 26),
                        ],
                        stops: [
                          0.1,
                          0.9,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            eventData.eventName.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans().copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yy').format(
                                DateTime.parse(eventData.eventDate.toString())),
                            style: GoogleFonts.plusJakartaSans().copyWith(
                              fontWeight: FontWeight.bold,
                              color: (themeData.brightness == Brightness.light)
                                  ? const Color.fromARGB(255, 8, 72, 20)
                                  : Theme.of(context).colorScheme.onBackground,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
