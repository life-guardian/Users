import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:user_app/model/alerts.dart';
import 'package:user_app/view_model/providers/alert_providert.dart';
import 'package:user_app/widget/error/no_data_found_image.dart';
import 'package:user_app/widget/text_widget/custom_text_widget.dart';

class AlertsListview extends StatefulWidget {
  const AlertsListview({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  State<AlertsListview> createState() => _AlertsListviewState();
}

class _AlertsListviewState extends State<AlertsListview> {
  late List<bool> isCardExpanded;

  late List<Alerts> alertsList;
  @override
  void initState() {
    super.initState();
    alertsList = widget.ref.watch(alertsProvider);
    isCardExpanded = List.generate(alertsList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: alertsList.isEmpty
          ? const NoDataFoundImage(
              headingText: "No Alerts Found !",
            )
          : ListView.builder(
              itemCount: alertsList.length,
              itemBuilder: (context, index) {
                final alertData = alertsList.elementAt(index);

                return SizedBox(
                  width: kIsWeb ? screenWidth / 1.5 : double.infinity,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isCardExpanded[index] == true) {
                          isCardExpanded[index] =
                              isCardExpanded[index] ? false : true;
                          return;
                        }

                        isCardExpanded =
                            List.generate(alertsList.length, (index) => false);
                        isCardExpanded[index] =
                            isCardExpanded[index] ? false : true;
                      });
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextWidget(
                                        text: alertData.alertName.toString(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomTextWidget(
                                        text: alertData.locality.toString(),
                                        color: const Color.fromARGB(
                                            255, 114, 114, 114),
                                        fontSize: 12,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomTextWidget(
                                        text: DateFormat('dd/MM/yy').format(
                                            DateTime.parse(alertData
                                                .alertForDate
                                                .toString())),
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
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CustomTextWidget(
                                          text: alertData.alertSeverity
                                              .toString(),
                                          color: (themeData.brightness ==
                                                  Brightness.light)
                                              ? const Color.fromARGB(
                                                  255, 158, 18, 8)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                          fontSize: 12,
                                        ),
                                        const SizedBox(
                                          height: 31,
                                        ),
                                        CustomTextWidget(
                                          text: alertData.agencyName.toString(),
                                          color: (themeData.brightness ==
                                                  Brightness.light)
                                              ? const Color.fromARGB(
                                                  255, 158, 18, 8)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (alertData.alertDescription != null)
                                const SizedBox(
                                  height: 20,
                                ),
                              if (alertData.alertDescription != null)
                                CustomTextWidget(
                                  text:
                                      "Description: ${alertData.alertDescription!}",
                                  color:
                                      (themeData.brightness == Brightness.light)
                                          ? const Color.fromARGB(255, 0, 0, 0)
                                          : Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                  textOverflow: isCardExpanded[index]
                                      ? null
                                      : TextOverflow.ellipsis,
                                  fontSize: 14,
                                ),
                            ],
                          ),
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
