// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/model/agencies_details.dart';
import 'package:user_app/view/screens/details_screen.dart';
import 'package:user_app/view/animations/transitions_animations/custom_page_transition.dart';
import 'package:user_app/widget/error/no_data_found_image.dart';

class AgenciesListListview extends StatelessWidget {
  const AgenciesListListview({
    super.key,
    required this.list,
    required this.scrollController,
    required this.isLoadingMore,
    required this.token,
    required this.userName,
  });
  final List<Agencies> list;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final String userName;
  final token;
  // final String sId;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: list.isEmpty
          ? const NoDataFoundImage(
              headingText: "No Agencies Found!",
            )
          : ListView.builder(
              itemCount: isLoadingMore ? list.length + 1 : list.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                if (index < list.length) {
                  final alertData = list.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CustomSlideTransition(
                          direction: AxisDirection.left,
                          child: DetailsScreen(
                              eventId: alertData.sId!,
                              token: token,
                              userName: userName,
                              screenType: 'AgencyDetails'),
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
                            horizontal: 10,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                alertData.name.toString(),
                                style: GoogleFonts.plusJakartaSans().copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Head: ${alertData.representativeName.toString()}',
                                style: GoogleFonts.plusJakartaSans().copyWith(
                                  color:
                                      (themeData.brightness == Brightness.light)
                                          ? const Color.fromARGB(255, 8, 72, 20)
                                          : Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
