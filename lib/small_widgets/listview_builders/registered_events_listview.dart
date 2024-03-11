// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_app/providers/program_events_provider.dart';

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
                                ? const Color.fromARGB(255, 224, 28, 14)
                                : Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
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
