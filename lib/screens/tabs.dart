// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:user_app/api_urls/config.dart';
import 'package:user_app/constants/sizes.dart';
import 'package:user_app/providers/alert_providert.dart';
import 'package:user_app/providers/program_events_provider.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/screens/login_screen.dart';
import 'package:user_app/screens/user_account_details.dart';
import 'package:user_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/small_widgets/custom_text_widgets/custom_text_widget.dart';

class TabsBottom extends ConsumerStatefulWidget {
  const TabsBottom({
    super.key,
    required this.token,
  });
  final token;

  @override
  ConsumerState<TabsBottom> createState() => _TabsBottomState();
}

class _TabsBottomState extends ConsumerState<TabsBottom> {
  int _currentIndx = 0;
  bool dataLoaded = true;
  Widget activePage = const Center(
    child: CircularProgressIndicator(
      color: Colors.grey,
    ),
  );

  String? userName;

  @override
  void initState() {
    super.initState();

    getNameSharedPreference();

    // get location when the page loads
    getLocation();
    Timer.periodic(const Duration(minutes: 10), (timer) {
      // put device location after per 15 minutes
      getLocation();
    });
  }

  @override
  void dispose() {
    super.dispose();
    getLocation();
    ref.read(nearbyEventsProvider.notifier).clearData();
    ref.read(registeredEventsProvider.notifier).clearData();
    ref.read(alertsProvider.notifier).clearData();
  }

  Future<void> getNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username');
    });
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Location permission denied");
      }
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      universalLat = currentPosition.latitude;
      universaLng = currentPosition.longitude;
      debugPrint("Latitude: $universalLat , Longitude: $universaLng");
      putLocation(lat: universalLat!, lng: universaLng!);
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint("Location permission is denied forever");
    }
  }

  Future<void> putLocation({required double lat, required double lng}) async {
    var reqBody = {"latitude": lat, "longitude": lng};

    await http.put(
      Uri.parse(putDeviceLocationUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode(reqBody),
    );

    // jsonDecode(response.body);

    setState(() {
      dataLoaded = true;
      activePage = HomeScreen(
        token: widget.token,
        userName: userName ?? "",
      );
    });
  }

  void onSelectedTab(int index) {
    setState(
      () {
        _currentIndx = index;
      },
    );
  }

  void showCircularProgressBar() {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
          ),
        );
      },
    );
  }

  void resetAllProviders() {
    ref.read(alertsProvider.notifier).clearData();
    ref.read(nearbyEventsProvider.notifier).clearData();
    ref.read(registeredEventsProvider.notifier).clearData();
  }

  void _logoutUser() async {
    showCircularProgressBar();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('username');
      while (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const WelcomeScreen(),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );
    } catch (error) {
      debugPrint("Logout user exception: ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (dataLoaded) {
      activePage = HomeScreen(
        token: widget.token,
        userName: userName ?? "",
      );
    }

    if (_currentIndx == 1) {
      activePage = UserAccountDetails(
        logoutUser: _logoutUser,
      );
    }

    return Scaffold(
      // backgroundColor: Colors.grey.shade200,
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: screenWidth > mobileScreenWidth
          ? activeScreenWeb(context: context)
          : SafeArea(
              child: activeScreen(),
            ),
      bottomNavigationBar: screenWidth > mobileScreenWidth || !dataLoaded
          ? null
          : BottomNavigationBar(
              unselectedItemColor: const Color.fromARGB(175, 158, 158, 158),
              currentIndex: _currentIndx,
              iconSize: 25,
              onTap: onSelectedTab,
              selectedItemColor: const Color.fromARGB(255, 91, 32, 217),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined),
                  activeIcon: Icon(Icons.account_circle_rounded),
                  label: 'Account',
                ),
              ],
            ),
    );
  }

  Widget activeScreenWeb({required BuildContext context}) {
    return Row(
      children: [
        navigationBarWeb(context: context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: activeScreen(),
          ),
        ),
      ],
    );
  }

  Widget navigationBarWeb({required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentIndx = 0;
                      });
                    },
                    icon: Icon(
                      _currentIndx == 0
                          ? Icons.home_rounded
                          : Icons.home_outlined,
                      color: _currentIndx == 0
                          ? const Color.fromARGB(233, 91, 32, 217)
                          : Colors.grey,
                      size: _currentIndx == 0 ? 50 : 40,
                    ),
                  ),
                  const CustomTextWidget(
                    text: "Home",
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentIndx = 1;
                      });
                    },
                    icon: Icon(
                      _currentIndx == 0
                          ? Icons.account_circle_outlined
                          : Icons.account_circle_rounded,
                      color: _currentIndx == 1
                          ? const Color.fromARGB(233, 91, 32, 217)
                          : Colors.grey,
                      size: _currentIndx == 1 ? 50 : 40,
                    ),
                  ),
                  const CustomTextWidget(
                    text: "Account",
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget activeScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.background,
          ],
          stops: const [
            0.5,
            1,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: activePage,
    );
  }
}
