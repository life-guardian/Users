// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:user_app/constants/sizes.dart';
import 'package:user_app/providers/user_details_provider.dart';
import 'package:user_app/widgets/custom_card_widget.dart';
import 'package:user_app/screens/features_screen.dart';
import 'package:user_app/screens/maps_screen.dart';
import 'package:user_app/widgets/custom_text_widgets/custom_text_widget.dart';
import 'package:user_app/animations/transitions_animations/custom_page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.token,
    required this.userName,
    required this.ref,
  });
  final token;
  final String userName;
  final WidgetRef ref;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String dayOfWeek;
  late String formattedDate;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    loadAllRequiredData();
  }

  void loadAllRequiredData() {
    final now = DateTime.now();
    dayOfWeek = DateFormat('EEEE').format(now); // Monday, Tuesday, etc.
    formattedDate = DateFormat('dd MMMM').format(now);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    _pickedImage = widget.ref.watch(profileImageProvider);
    String grettingMessage = widget.ref.watch(greetingProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
      // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayOfWeek,
                        style: GoogleFonts.abhayaLibre(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xff7F7F7F),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextWidget(
                        text: formattedDate,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ],
                  ),
                  if (_pickedImage != null)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return FadeInUp(
                              duration: const Duration(milliseconds: 500),
                              child: AlertDialog(
                                content: Image(
                                  image: FileImage(
                                    File(_pickedImage!.path),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: FileImage(File(_pickedImage!.path)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 31,
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: (widget.userName != "")
                        ? '$grettingMessage! ${widget.userName}'
                        : "Loading...",
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    'Be prepared and Stay Protected!',
                    style: GoogleFonts.archivo(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff8D8D8D),
                    ),
                  ),
                  // code here for card view
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        // stops: [0.1, 0.8],
                        colors: [
                          Color.fromARGB(255, 120, 103, 232),
                          Color(0xff5451D6),
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomTextWidget(
                                text: 'Life Guardian',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              const Flexible(
                                child: CustomTextWidget(
                                  text:
                                      'Disaster Safety, all in one app. Stay prepared, stay safe.',
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: Stack(
                                  children: [
                                    Image.asset('assets/logos/ellipse1.png'),
                                    Positioned(
                                      left: 15,
                                      child: Image.asset(
                                          'assets/logos/ellipse2.png'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          screenWidth < mobileScreenWidth
                              ? Expanded(
                                  child: Image.asset(
                                      'assets/images/disasterImage2.jpg'))
                              : SizedBox(
                                  width: screenWidth / 13,
                                  child: Image.asset(
                                    'assets/images/disasterImage2.jpg',
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 13,
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: 'Salient Features',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  CustomSlideTransition(
                                    direction: AxisDirection.left,
                                    child: MapsScreen(
                                      token: widget.token,
                                    ),
                                  ),
                                );
                              },
                              child: const CustomCardWidget(
                                width: 170,
                                height: 120,
                                color1: Color(0xffFFA0BC),
                                color2: Color(0xffFF1B5E),
                                title: 'Maps',
                                desc: 'Nearby agencies and Help!',
                              ),
                            ),
                            const SizedBox(
                              height: 11,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  CustomSlideTransition(
                                    direction: AxisDirection.left,
                                    child: FeaturesScreen(
                                      screenType: 'ProgramEvents',
                                      token: widget.token,
                                      username: widget.userName,
                                    ),
                                  ),
                                );
                              },
                              child: const CustomCardWidget(
                                width: 170,
                                height: 170,
                                color1: Color(0xffA9FFEA),
                                color2: Color(0xff00B288),
                                title: 'Programs & Events',
                                desc: 'Nearby',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  CustomSlideTransition(
                                    direction: AxisDirection.left,
                                    child: FeaturesScreen(
                                      token: widget.token,
                                      screenType: 'SearchAgency',
                                      username: widget.userName,
                                    ),
                                  ),
                                );
                              },
                              child: const CustomCardWidget(
                                width: 170,
                                height: 170,
                                color1: Color(0xffB1EEFF),
                                color2: Color(0xff29BAE2),
                                title: 'Search',
                                desc: 'Agency details',
                              ),
                            ),
                            const SizedBox(
                              height: 11,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  CustomSlideTransition(
                                    direction: AxisDirection.left,
                                    child: FeaturesScreen(
                                      token: widget.token,
                                      screenType: 'AlertsScreen',
                                      username: widget.userName,
                                    ),
                                  ),
                                );
                              },
                              child: const CustomCardWidget(
                                width: 170,
                                height: 120,
                                color1: Color(0xffFFD29D),
                                color2: Color(0xffFF9E2D),
                                title: 'Alerts',
                                desc: 'Active',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
