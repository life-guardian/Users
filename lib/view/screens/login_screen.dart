// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:user_app/helper/constants/sizes.dart';
import 'package:user_app/helper/functions/validate_textfields.dart';
import 'package:user_app/view/screens/tabs.dart';
import 'package:user_app/widget/circular_progress_indicator/custom_circular_progress_indicator.dart';
import 'package:user_app/widget/dialogs/custom_show_dialog.dart';
import 'package:user_app/helper/constants/api_keys.dart';
import 'package:user_app/view/screens/register_screen.dart';
import 'package:user_app/view/animations/transitions_animations/custom_page_transition.dart';
import 'package:user_app/widget/textfields/textfield_widget.dart';
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
    Theme.of(context);
    final size = MediaQuery.of(context).size;
    bool kIsMobile = (size.width <= mobileScreenWidth);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Column(
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
                        FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            'Welcome back! Glad to see you, Stay Safe!',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 31,
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            children: [
                              SizedBox(
                                width: !kIsMobile ? size.width / 2 : null,
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
                                width: !kIsMobile ? size.width / 2 : null,
                                child: TextFieldWidget(
                                  labelText: 'Password',
                                  controllerText: userPassword,
                                  checkValidation: (value) =>
                                      validateTextField(value, 'Password'),
                                  obsecureIcon: true,
                                  hideText: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 41,
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 500),
                          child: SizedBox(
                            width:
                                !kIsMobile ? size.width / 4 : double.infinity,
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
                                  ? const CustomCircularProgressIndicator()
                                  : const Text('Login'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
