// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/providers/user_details_provider.dart';
import 'package:user_app/widgets/custom_dialogs/custom_logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:user_app/widgets/custom_text_widgets/custom_text_widget.dart';
import 'package:user_app/widgets/dividers/horizontal_divider.dart';

class UserAccountDetails extends StatefulWidget {
  const UserAccountDetails({
    super.key,
    required this.logoutUser,
    required this.ref,
    this.username,
  });
  final void Function() logoutUser;
  final WidgetRef ref;
  final String? username;

  @override
  State<UserAccountDetails> createState() => _UserAccountDetailsState();
}

class _UserAccountDetailsState extends State<UserAccountDetails> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  late SharedPreferences prefs;

  Future<XFile?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    return image;
  }

  @override
  Widget build(BuildContext context) {
    _pickedImage = widget.ref.watch(profileImageProvider);
    bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: "Settings",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(
                height: 21,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    if (isLightMode)
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 20,
                        offset:
                            const Offset(0, 10), // changes position of shadow
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                child: AlertDialog(
                                  content: Image(
                                    image: FileImage(
                                      File(_pickedImage!.path),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: _pickedImage != null
                              ? Image(
                                  image: FileImage(
                                    File(
                                      _pickedImage!.path,
                                    ),
                                  ),
                                  fit: BoxFit.fitHeight,
                                ).image
                              : null,
                        ),
                      ),
                      const SizedBox(
                        height: 31,
                      ),
                      CustomTextWidget(
                        text: widget.username ?? "",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 31,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    if (isLightMode)
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 20,
                        offset:
                            const Offset(0, 10), // changes position of shadow
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          _pickedImage = await pickImageFromGallery();
                          if (_pickedImage != null) {
                            widget.ref
                                .read(profileImageProvider.notifier)
                                .state = _pickedImage;

                            setState(() {});
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.camera_alt_outlined),
                              SizedBox(
                                width: 21,
                              ),
                              CustomTextWidget(
                                text: 'Update Profile Photo',
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                      ),
                      const HorizontalDivider(),
                      InkWell(
                        onTap: () {
                          // navigate to help page
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.help_center_rounded),
                              SizedBox(
                                width: 21,
                              ),
                              CustomTextWidget(
                                text: 'Learn More!',
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                      ),
                      const HorizontalDivider(),
                      InkWell(
                        onTap: () {
                          customLogoutDialog(
                              context: context,
                              titleText: 'Change Password?',
                              onTap: () {},
                              actionText2: 'Yes',
                              contentText:
                                  'Do you really want to reset your password');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.lock_clock_rounded),
                              SizedBox(
                                width: 21,
                              ),
                              CustomTextWidget(
                                text: 'Change Password!',
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                      ),
                      const HorizontalDivider(thickness: 0.5),
                      InkWell(
                        onTap: () {
                          customLogoutDialog(
                            context: context,
                            titleText: 'Log out?',
                            contentText:
                                'You will logged out from your account!',
                            actionText2: 'Log Out',
                            onTap: widget.logoutUser,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.logout_rounded),
                              SizedBox(
                                width: 21,
                              ),
                              CustomTextWidget(
                                text: 'Logout',
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 31,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Life ',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const Text(
                        'Guardian',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w900,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 25,
                        child: Image.asset(
                          'assets/images/disasterImage2.jpg',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
