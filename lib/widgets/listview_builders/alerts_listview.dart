import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_app/providers/alert_providert.dart';
import 'package:user_app/widgets/custom_images/no_data_found_image.dart';

class AlertsListview extends StatelessWidget {
  const AlertsListview({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final alertsList = ref.watch(alertsProvider);
    return alertsList.isEmpty
        ? const NoDataFoundImage(
            headingText: "No Alerts Found !",
          )
        : ListView.builder(
            itemCount: alertsList.length,
            itemBuilder: (context, index) {
              final alertData = alertsList.elementAt(index);
              return SizedBox(
                width: kIsWeb ? screenWidth / 1.5 : double.infinity,
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
                          Color.fromARGB(41, 106, 51, 47),
                          Color.fromARGB(157, 177, 12, 0),
                        ],
                        stops: [
                          0.1,
                          0.9,
                        ],
                      ),
                    ),
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
                                  color:
                                      const Color.fromARGB(255, 114, 114, 114),
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
                                  color: (themeData.brightness ==
                                          Brightness.light)
                                      ? const Color.fromARGB(255, 224, 28, 14)
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground,
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
                                    color: (themeData.brightness ==
                                            Brightness.light)
                                        ? const Color.fromARGB(255, 158, 18, 8)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground,
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
                                    color: (themeData.brightness ==
                                            Brightness.light)
                                        ? const Color.fromARGB(255, 158, 18, 8)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
