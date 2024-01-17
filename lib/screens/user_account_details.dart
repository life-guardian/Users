// ignore_for_file: use_build_context_synchronously
import 'package:user_app/small_widgets/custom_dialogs/custom_logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserAccountDetails extends StatelessWidget {
  const UserAccountDetails({
    super.key,
    required this.logoutUser,
  });
  final void Function() logoutUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logos/indiaflaglogo.png'),
              const SizedBox(
                width: 21,
              ),
              Text(
                'Agency Name',
                // email,
                style: GoogleFonts.plusJakartaSans().copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 31,
          ),
          InkWell(
            onTap: () {
              customLogoutDialog(
                  context: context,
                  titleText: 'Forgot Password?',
                  onTap: () {},
                  actionText2: 'Yes',
                  contentText: 'Do you really want to reset your password');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Forgot Password?',
                    style: GoogleFonts.mulish(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          InkWell(
            onTap: () {
              customLogoutDialog(
                context: context,
                titleText: 'Log out of your account?',
                contentText:
                    'You will logged out and navigated to login dashboard',
                actionText2: 'Log Out',
                onTap: logoutUser,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Log Out',
                    style: GoogleFonts.mulish(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Jai ',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Hind !',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
