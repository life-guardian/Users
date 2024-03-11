import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_app/models/alerts.dart';
import 'package:user_app/providers/alert_providert.dart';

class AlertsListview extends StatelessWidget {
  const AlertsListview({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final alertsList = ref.watch(alertsProvider);
    return alertsList.isEmpty
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
            itemCount: alertsList.length,
            itemBuilder: (context, index) {
              final alertData = alertsList.elementAt(index);
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alertData.alertName.toString(),
                            style: GoogleFonts.plusJakartaSans().copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            alertData.locality.toString(),
                            style: GoogleFonts.plusJakartaSans().copyWith(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateFormat('dd/MM/yy').format(DateTime.parse(
                                alertData.alertForDate.toString())),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              alertData.alertSeverity.toString(),
                              style: GoogleFonts.plusJakartaSans().copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 31,
                            ),
                            Text(
                              alertData.agencyName.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans().copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
