// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:user_app/constants/sizes.dart';
import 'package:user_app/custom_functions/validate_textfields.dart';
import 'package:user_app/screens/tabs.dart';
import 'package:user_app/small_widgets/custom_dialogs/custom_show_dialog.dart';
import 'package:user_app/api_urls/config.dart';
import 'package:user_app/screens/register_screen.dart';
import 'package:user_app/transitions_animations/custom_page_transition.dart';
import 'package:user_app/small_widgets/custom_textfields/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userLoginEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  late SharedPreferences prefs;
  bool isLogging = false;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  @override
  void dispose() {
    super.dispose();
    userLoginEmail.dispose();
    userPassword.dispose();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _goToRegisterPage() {
    Navigator.of(context).pushReplacement(
      CustomSlideTransition(
        direction: AxisDirection.up,
        child: const RegisterScreen(),
      ),
    );
  }

  void _navigateToHomeScreen({required final token}) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => TabsBottom(token: token),
      ),
    );
  }

  void _submitButton() {
    if (_formKey.currentState!.validate()) {
      if (!buttonPressed) {
        buttonPressed = true;
        _loginUser();
      }
    }
  }

  void _loginUser() async {
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (ctx) => const Center(
    //     child: CircularProgressIndicator(
    //       color: Colors.grey,
    //     ),
    //   ),
    // );
    setState(() {
      isLogging = true;
    });

    var reqBody = {
      "username": userLoginEmail.text,
      "password": userPassword.text,
      "locationCoordinates": ["76.10955", "17.99112"]
    };

    var response = await http.post(
      Uri.parse(loginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    String? userName;
    var jsonResponse = jsonDecode(response.body);
    String message = jsonResponse['message'];
    if (response.statusCode == 200) {
      userName = jsonResponse['data']['name'];
      //storin user login data in local variable
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);
      prefs.setString('username', userName!);
      // Navigator.of(context).pop();
      _navigateToHomeScreen(token: myToken);
      //success
    } else {
      setState(() {
        isLogging = false;
      });

      buttonPressed = await customShowDialog(
        context: context,
        titleText: 'Something went wrong',
        contentText: message,
      );
      buttonPressed = false;
      return;
    }

    setState(() {
      isLogging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    bool kIsMobile = (screenWidth <= mobileScreenWidth);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              foregroundColor: (themeData.brightness == Brightness.light)
                  ? const Color.fromARGB(185, 30, 35, 44)
                  : const Color(0xffe1dcd3),
              side: BorderSide(
                color: (themeData.brightness == Brightness.light)
                    ? const Color.fromARGB(32, 30, 35, 44)
                    : const Color(0xffE1DCD3),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/disasterImage2.jpg'),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Life Guardian',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    shadows: const [
                      Shadow(
                        offset: Offset(0.0, 7.0),
                        blurRadius: 15.0,
                        color: Color.fromARGB(57, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 31,
                ),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Welcome back! Glad to see you, Stay Safe!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 31,
                        ),
                        SizedBox(
                          width: !kIsMobile ? screenWidth / 2 : null,
                          child: TextFieldWidget(
                            labelText: 'Email / Phone',
                            controllerText: userLoginEmail,
                            checkValidation: (value) =>
                                validateTextField(value, 'Email / Phone'),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: !kIsMobile ? screenWidth / 2 : null,
                          child: TextFieldWidget(
                            labelText: 'Password',
                            controllerText: userPassword,
                            checkValidation: (value) =>
                                validateTextField(value, 'Password'),
                            obsecureIcon: true,
                            hideText: true,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const SizedBox(
                          height: 31,
                        ),
                        SizedBox(
                          width: !kIsMobile ? screenWidth / 4 : double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _submitButton,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isLogging
                                ? const Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: _goToRegisterPage,
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
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
  }
}
