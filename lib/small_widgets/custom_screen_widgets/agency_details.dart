import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AgencyDetails extends StatelessWidget {
  const AgencyDetails({
    super.key,
    required this.agencyName,
    required this.agencyEmail,
    required this.representativeName,
    required this.agencyAddress,
    required this.rescueOperations,
    required this.eventsOrganized,
    required this.agencyPhone,
  });
  final String agencyName;
  final String agencyEmail;
  final String representativeName;
  final String agencyAddress;
  final int rescueOperations;
  final int eventsOrganized;
  final int agencyPhone;

  @override
  Widget build(BuildContext context) {
    Future<void> launchPhoneDial({required int phoneNo}) async {
      final Uri url = Uri(
        scheme: 'tel',
        path: phoneNo.toString(),
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        debugPrint("Cannot launch phoneCall url");
      }
    }

    // ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 12,
        right: 12,
        bottom: 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agency Details',
            style: GoogleFonts.mulish().copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agency Name'.toUpperCase(),
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              Text(
                agencyName,
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email'.toUpperCase(),
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              Text(
                agencyEmail,
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Representative Name'.toUpperCase(),
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              Text(
                representativeName,
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address'.toUpperCase(),
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              Text(
                agencyAddress,
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rescue Operations'.toUpperCase(),
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              Text(
                rescueOperations.toString(),
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events Organized'.toUpperCase(),
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              Text(
                eventsOrganized.toString(),
                style: GoogleFonts.mulish().copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Icon(
                Icons.star_border_outlined,
                size: 30,
                color: Colors.blue,
              ),
              const SizedBox(
                width: 11,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agency Phone'.toUpperCase(),
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    agencyPhone.toString(),
                    style: GoogleFonts.mulish().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // const Divider(thickness: 0.2),
          const Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    await launchPhoneDial(
                      phoneNo: agencyPhone,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: const Color(0xff1E232C),
                  ),
                  child: const Text(
                    'CALL',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
