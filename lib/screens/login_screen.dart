// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
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

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? _validateTextField(value, String? label) {
    if (value.isEmpty) {
      return 'Please enter a $label';
    }
    return null;
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
    
    var jsonResponse = jsonDecode(response.body);
    var message = jsonResponse['message'];
    if (response.statusCode == 200) {
      //storin user login data in local variable
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      TextFieldWidget(
                        labelText: 'Email / Phone',
                        controllerText: userLoginEmail,
                        checkValidation: (value) =>
                            _validateTextField(value, 'Email / Phone'),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFieldWidget(
                        labelText: 'Password',
                        controllerText: userPassword,
                        checkValidation: (value) =>
                            _validateTextField(value, 'Password'),
                        obsecureIcon: true,
                        hideText: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(
                        height: 31,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _submitButton,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff1E232C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLogging
                              ? const Expanded(
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
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
    );
  }
}
