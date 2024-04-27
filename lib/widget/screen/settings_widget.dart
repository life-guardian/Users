// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
                        settingsTile(
                          text: 'Update Profile Photo',
                          leadingIcon: Icons.camera_alt_outlined,
                          ontap: () async {
                            _pickedImage = await pickImageFromGallery();
                            if (_pickedImage != null) {
                              widget.ref
                                  .read(profileImageProvider.notifier)
                                  .state = _pickedImage;

                              setState(() {});
                            }
                          },
                        ),
                        const HorizontalDivider(),
                        settingsTile(
                          text: 'Learn More!',
                          leadingIcon: Icons.help_center_rounded,
                          ontap: () => launchWebUrl(),
                        ),
                        const HorizontalDivider(),
                        settingsTile(
                            text: 'Change Password?',
                            leadingIcon: Icons.lock_clock_rounded,
                            ontap: () {
                              customLogoutDialog(
                                  context: context,
                                  titleText: 'Change Password?',
                                  onTap: () {},
                                  actionText2: 'Yes',
                                  contentText:
                                      'Do you really want to reset your password');
                            }),
                        const HorizontalDivider(),
                        settingsTile(
                          text: 'Share App',
                          leadingIcon: Icons.share_outlined,
                          ontap: () async {
                            String url =
                                "https://lifeguardian-users.netlify.app/";
                            await Share.share("Lifeguardian Users app\n\n$url");
                          },
                        ),
                        const HorizontalDivider(thickness: 0.5),
                        settingsTile(
                          text: 'Logout',
                          leadingIcon: Icons.logout_rounded,
                          ontap: () {
                            customLogoutDialog(
                              context: context,
                              titleText: 'Log out?',
                              contentText:
                                  'You will logged out from your account!',
                              actionText2: 'Log Out',
                              onTap: widget.logoutUser,
                            );
                          },
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

  Widget settingsTile({
    required String text,
    required IconData leadingIcon,
    required Function() ontap,
  }) {
    return InkWell(
      onTap: () => ontap(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              leadingIcon,
            ),
            const SizedBox(
              width: 21,
            ),
            CustomTextWidget(
              text: text,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launchWebUrl() async {
    final Uri url = Uri.parse(
        'https://tejxcoder01.blogspot.com/2024/04/what-is-life-guardian-rescue-system.html');

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
