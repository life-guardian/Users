// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/view_model/providers/user_details_provider.dart';
import 'package:user_app/widget/dialogs/custom_logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:user_app/widget/text_widget/custom_liefguardian_tag.dart';
import 'package:user_app/widget/text_widget/custom_text_widget.dart';
import 'package:user_app/widget/divider/horizontal_divider.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    super.key,
    required this.logoutUser,
    required this.ref,
    this.username,
  });
  final void Function() logoutUser;
  final WidgetRef ref;
  final String? username;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
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
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 3,
                  color: Theme.of(context).colorScheme.primary,
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
                                    backgroundColor: Colors.transparent,
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
              ),
              const SizedBox(
                height: 31,
              ),
              Card(
                elevation: 3,
                color: Theme.of(context).colorScheme.primary,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primary,
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
                        const HorizontalDivider(),
                        InkWell(
                          onTap: () async {
                            String url =
                                "https://lifeguardian-users.netlify.app/";
                            await Share.share("Lifeguardian Users app\n\n$url");
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.share_outlined),
                                SizedBox(
                                  width: 21,
                                ),
                                CustomTextWidget(
                                  text: 'Share App',
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
              ),
              const SizedBox(
                height: 31,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomLifeGuardianTag(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
