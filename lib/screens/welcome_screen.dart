import 'package:user_app/screens/login_screen.dart';
import 'package:user_app/screens/register_screen.dart';
import 'package:user_app/transitions_animations/custom_page_transition.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _login(BuildContext context) {
    Navigator.of(context).push(
      CustomSlideTransition(
        direction: AxisDirection.left,
        child: const LoginScreen(),
      ),
    );
  }

  void _register(BuildContext context) {
    Navigator.of(context).push(
      CustomSlideTransition(
        direction: AxisDirection.left,
        child: const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: double.infinity,
                child: Image.asset('assets/images/disasterImage1.png'),
              ),
              Image.asset('assets/images/disasterImage2.jpg'),
              const SizedBox(
                width: double.infinity,
                height: 12,
              ),
              Text(
                'Life Guardian',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
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
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff1E232C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    _register(context);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: (themeData.brightness == Brightness.light)
                        ? const Color(0xff1E232C)
                        : Colors.white,
                    side: BorderSide(
                      color: (themeData.brightness == Brightness.light)
                          ? const Color(0xff1E232C)
                          : Colors.white,
                    ),
                  ),
                  child: const Text("Register"),
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  'Jai Hind !',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
