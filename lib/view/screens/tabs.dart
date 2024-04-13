// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_app/helper/constants/api_keys.dart';
import 'package:user_app/helper/constants/sizes.dart';
import 'package:user_app/view/animations/home_screen_shimmer_effect.dart';
import 'package:user_app/view_model/providers/alert_providert.dart';
import 'package:user_app/view_model/providers/device_location_provider.dart';
import 'package:user_app/view_model/providers/program_events_provider.dart';
import 'package:user_app/view_model/providers/user_details_provider.dart';
import 'package:user_app/widget/screen/home_widget.dart';
import 'package:user_app/view/screens/login_screen.dart';
import 'package:user_app/widget/screen/settings_widget.dart';
import 'package:user_app/view/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/widget/text_widget/custom_text_widget.dart';

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
  bool dataLoaded = false;
  Widget activePage = const HomeScreenShimmerAnimation();

  String? userName;

  @override
  void initState() {
    super.initState();

    getNameSharedPreference();

    // get location when the page loads
    getLocation();
    getImageFileFromAssets('assets/images/no-profile-photo.jpeg')
        .then((value) => ref.read(profileImageProvider.notifier).state = value);
    Timer.periodic(const Duration(minutes: 1), (timer) {
      getLocation();
    });
  }

  @override
  void dispose() {
    super.dispose();
    resetAllProviders();
  }

  Future<XFile> getImageFileFromAssets(String path) async {
    final ByteData byteData = await rootBundle.load(path);
    final List<int> bytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final fileName = path.split('/').last; // Extracting filename from the path
    final tempFilePath = '${tempDir.path}/$fileName';
    await File(tempFilePath).writeAsBytes(bytes);
    return XFile(tempFilePath);
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

      debugPrint("${currentPosition.latitude} :  ${currentPosition.longitude}");

      ref.read(deviceLocationProvider.notifier).state = [
        currentPosition.latitude,
        currentPosition.longitude
      ];
      List<double> latLng = ref.read(deviceLocationProvider);
      putLocation(lat: latLng[0], lng: latLng[1]);
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint("Location permission is denied forever");
    }
    setState(() {
      dataLoaded = true;
      activePage = HomeWidget(
        token: widget.token,
        userName: userName ?? "",
        ref: ref,
      );
    });
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
  }

  void onSelectedTab(int index) {
    setState(
      () {
        _currentIndx = index;
      },
    );
  }

  void resetAllProviders() {
    ref.read(alertsProvider.notifier).clearData();
    ref.read(nearbyEventsProvider.notifier).clearData();
    ref.read(registeredEventsProvider.notifier).clearData();
  }

  void _logoutUser() async {
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
    ThemeData themeData = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    if (dataLoaded) {
      activePage = HomeWidget(
        token: widget.token,
        userName: userName ?? "",
        ref: ref,
      );
    }

    if (_currentIndx == 1) {
      activePage = SettingsWidget(
        username: userName,
        logoutUser: _logoutUser,
        ref: ref,
      );
    }

    return Scaffold(
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
              selectedItemColor: (themeData.brightness == Brightness.light)
                  ? const Color.fromARGB(255, 91, 32, 217)
                  : const Color.fromARGB(255, 161, 161, 161),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined),
                  activeIcon: Icon(Icons.account_circle_rounded),
                  label: 'Settings',
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
                    text: "Settings",
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
