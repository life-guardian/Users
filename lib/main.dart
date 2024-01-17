// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:user_app/screens/tabs.dart';
import 'package:user_app/screens/welcome_screen.dart';
import 'package:user_app/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final myToken = prefs.getString('token');

  runApp(
    MyApp(
      token: myToken,
      // prefs: myToken`,
    ),
  );
}

class MyApp extends StatelessWidget {
  final token;
  // final String? prefs;

  const MyApp({super.key, required this.token});

  Widget startScreen() {
    Widget activeScreen = const WelcomeScreen();
    // (JwtDecoder.isExpired(token))
    if (token != null) {
      activeScreen = (token == ''
          ? const WelcomeScreen()
          : TabsBottom(
              token: token,
            ));
    }
    return activeScreen;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Angencies',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: startScreen(),
    );
  }
}
