// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/helper/constants/api_keys.dart';
import 'package:user_app/helper/constants/sizes.dart';
import 'package:user_app/view/screens/login_screen.dart';
import 'package:user_app/view/screens/register_succesful.dart';
import 'package:user_app/widget/circular_progress_indicator/custom_circular_progress_indicator.dart';
import 'package:user_app/widget/dialogs/custom_show_dialog.dart';
import 'package:user_app/view/animations/transitions_animations/custom_page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/widget/textfields/textfield_widget.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userConfirmPassword = TextEditingController();
  bool registerButtonPressed = false;
  bool isLoging = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    phoneNumber.dispose();
    address.dispose();
    password.dispose();
    userConfirmPassword.dispose();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void popScreen() {
    Navigator.of(context).pop();
  }

  void goToLoginPage() {
    Navigator.of(context).pushReplacement(
      CustomSlideTransition(
        direction: AxisDirection.up,
        child: const LoginScreen(),
      ),
    );
  }

  String? validateemail(value, String? label) {
    if (value.isEmpty) {
      return 'Please enter an $label';
    }
    RegExp emailRegx = RegExp(r'^.+@[a-zA-Z]+\.[a-zA-Z]+$');
    if (!emailRegx.hasMatch(value)) {
      return 'Please enter a valid $label';
    }
    return null;
  }

  String? validatePhoneNo(value, String? label) {
    var no = int.tryParse(value);
    if (no == null) {
      return 'Please enter a valid $label';
    }
    if (value.isEmpty) {
      return 'Please enter a $label';
    }
    if (value.length != 10) {
      return 'Please enter a 10-digit $label';
    }
    return null;
  }

  String? validateTextField(value, String? label) {
    if (value.isEmpty) {
      return 'Please enter a $label';
    }
    return null;
  }

  String? validatePassword(value, String? label) {
    if (value.isEmpty) {
      return 'Please enter a $label';
    }
    if (value.length < 8 || value.length > 16) {
      return 'Please enter $label between 8 to 16 digits';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*$').hasMatch(value)) {
      return 'Password must contains at least one upper case, lower case, number & special symbol';
    }

    return null;
  }

  String? validateConfirmPassword(value, String? label) {
    if (value.isEmpty) {
      return 'Please enter a $label';
    }
    String agPass = password.text.toString();
    if (agPass != value.toString()) {
      return 'Password and confirm password did\'t match';
    }

    return null;
  }

  String? validateName(value, String? label) {
    var no = int.tryParse(value);
    if (no != null) {
      return 'Please enter a valid $label';
    }
    if (value.isEmpty) {
      return 'Please enter a $label';
    }
    return null;
  }

  void registerUser() async {
    setState(() {
      isLoging = true;
    });

    var reqBody = {
      "name": name.text.toString(),
      "password": password.text.toString(),
      "phoneNumber": phoneNumber.text.toString(),
      "email": email.text.toString(),
      "address": address.text.toString(),
      // "locationCoordinates": ["18.9111", "76.9931"]
    };

    var response = await http.post(
      Uri.parse(registerurl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);
    var message = jsonResponse['message'];

    if (response.statusCode == 200) {
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);
      String? userName = jsonResponse['data']['name'];
      prefs.setString('username', userName!);
      Navigator.of(context).pushReplacement(
        CustomSlideTransition(
          direction: AxisDirection.left,
          child: RegisterSuccessfullScreen(token: myToken),
        ),
      );
    } else {
      setState(() {
        isLoging = false;
      });
      registerButtonPressed = await customShowDialog(
        context: context,
        titleText: 'Something went wrong',
        contentText: message,
      );
      return;
    }
    setState(() {
      isLoging = false;
    });
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      if (!registerButtonPressed) {
        registerButtonPressed = true;
        registerUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool kIsMobile = (screenWidth <= mobileScreenWidth);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: kIsMobile ? true : false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: !kIsMobile
              ? registerScreenWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  kIsMobile: kIsMobile)
              : registerScreenWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  kIsMobile: kIsMobile,
                ),
        ),
      ),
    );
  }

  Widget registerScreenWidget({
    required double screenHeight,
    required double screenWidth,
    required bool kIsMobile,
  }) {
    return SizedBox(
      child: Column(
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Text(
              'Hello! Register to get started',
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
          kIsMobile
              ? registerScreenFormWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  kIsMobile: kIsMobile,
                )
              : registerScreenFormWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  kIsMobile: kIsMobile,
                ),
          SizedBox(
            height: screenHeight / 10,
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: !kIsMobile
                  ? screenWidth / 4
                  : MediaQuery.of(context).size.width,
              height: 55,
              child: ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoging
                    ? const CustomCircularProgressIndicator()
                    : const Text('Register'),
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
                    'Already have an account?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: goToLoginPage,
                    child: const Text(
                      'Login Now',
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
    );
  }

  Widget registerScreenFormWidget(
      {required double screenHeight,
      required double screenWidth,
      required bool kIsMobile}) {
    return SizedBox(
      height: screenHeight / 2,
      child: SingleChildScrollView(
        child: FadeInUp(
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
            width: !kIsMobile ? screenWidth / 2 : null,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFieldWidget(
                    labelText: 'Name',
                    controllerText: name,
                    checkValidation: (value) => validateName(value, 'Name'),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  TextFieldWidget(
                    labelText: 'Email',
                    controllerText: email,
                    checkValidation: (value) => validateemail(value, 'email'),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  TextFieldWidget(
                    labelText: 'Phone No',
                    controllerText: phoneNumber,
                    checkValidation: (value) =>
                        validatePhoneNo(value, 'Phone Number'),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  TextFieldWidget(
                    labelText: 'Address',
                    controllerText: address,
                    checkValidation: (value) =>
                        validateTextField(value, 'Address'),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  TextFieldWidget(
                    labelText: 'Password',
                    controllerText: password,
                    checkValidation: (value) =>
                        validatePassword(value, 'Password'),
                    hideText: true,
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  TextFieldWidget(
                    labelText: 'Confirm Password',
                    controllerText: userConfirmPassword,
                    checkValidation: (value) =>
                        validateConfirmPassword(value, 'Confirm Password'),
                    hideText: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
