import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/helper/constants/sizes.dart';
import 'package:user_app/widget/app_bar/custom_events_appbar.dart';
import 'package:user_app/widget/screen/search_agency_widget.dart';

class SearchAgencyScreen extends ConsumerStatefulWidget {
  const SearchAgencyScreen({
    super.key,
    required this.token,
    required this.username,
  });

  final String token;
  final String username;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProgramEventsScreenState();
}

class _ProgramEventsScreenState extends ConsumerState<SearchAgencyScreen> {
  late Widget activeWidget;

  @override
  void initState() {
    super.initState();

    activeWidget = SearchAgencyWidget(
      userName: widget.username,
      token: widget.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomEventsAppBar(agencyName: widget.username),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Search by agency or representative name, email',
              style: GoogleFonts.rubik().copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color(0xff78746D),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                    bottom: 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: screenWidth > mobileScreenWidth
                              ? screenWidth / 1.5
                              : double.infinity,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 500),
                            child: activeWidget,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
