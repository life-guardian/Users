// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/models/agencies_details.dart';
import 'package:user_app/screens/details_screen.dart';
import 'package:user_app/transitions_animations/custom_page_transition.dart';

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
    // ThemeData themeData = Theme.of(context);
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
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Head: ${alertData.representativeName.toString()}',
                            style: GoogleFonts.plusJakartaSans().copyWith(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                );
              }
            },
          );
  }
}
