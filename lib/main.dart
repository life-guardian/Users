// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_app/view/screens/tabs.dart';
import 'package:user_app/view/screens/welcome_screen.dart';
import 'package:user_app/view/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/widget/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final myToken = prefs.getString('token');
  await dotenv.load(fileName: ".env");

  runApp(
    ProviderScope(
      child: MyApp(
        token: myToken,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget activeWidget;

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      activeWidget = const SplashScreen();
      assignAppScreen();
    } else {
      activeWidget = const WelcomeScreen();
    }
  }

  Widget assignAppScreen() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        activeWidget = TabsBottom(
          token: widget.token,
        );
        setState(() {});
      },
    );

    return activeWidget;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: activeWidget,
    );
  }
}
