import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obatin/shared_prefs_helper.dart';
import 'package:obatin/login_options_screen.dart';
import 'package:obatin/notification_service.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF2962FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Text(
                    'Kebijakan Privasi',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
            ),

            // Privacy Policy Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Policy\n\n'
                      'This privacy policy applies to the Obatin app (hereby referred to as "Application") for mobile devices that was created by Obat-Team (hereby referred to as "Service Provider") as a Free service. This service is intended for use "AS IS".\n\n'
                      'Information Collection and Use\n\n'
                      'The Application collects information when you download and use it. This information may include information such as\n'
                      'Your device\'s Internet Protocol address (e.g. IP address)\n'
                      'The pages of the Application that you visit, the time and date of your visit, the time spent on those pages\n'
                      'The time spent on the Application\n'
                      'The operating system you use on your mobile device\n\n'
                      'The Application collects your device\'s location, which helps the Service Provider determine your approximate geographical location and make use of in below ways:\n'
                      'Geolocation Services: The Service Provider utilizes location data to provide features such as personalized content, relevant recommendations, and location-based services.\n'
                      'Analytics and Improvements: Aggregated and anonymized location data helps the Service Provider to analyze user behavior, identify trends, and improve the overall performance and functionality of the Application.\n'
                      'Third-Party Services: Periodically, the Service Provider may transmit anonymized location data to external services. These services assist them in enhancing the Application and optimizing their offerings.\n\n'
                      'The Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.\n\n'
                      'For a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information, including but not limited to userId, full name, age, phone number, health data . The information that the Service Provider request will be retained by them and used as described in this privacy policy.\n\n'
                      'Third Party Access\n\n'
                      'Only aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement.\n\n'
                      'Please note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application:\n'
                      'Google Play Services\n\n'
                      'The Service Provider may disclose User Provided and Automatically Collected Information:\n'
                      'as required by law, such as to comply with a subpoena, or similar legal process;\n'
                      'when they believe in good faith that disclosure is necessary to protect their rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;\n'
                      'with their trusted services providers who work on their behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.\n\n'
                      'Opt-Out Rights\n\n'
                      'You can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.\n\n'
                      'Data Retention Policy\n\n'
                      'The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you\'d like them to delete User Provided Data that you have provided via the Application, please contact them at chouioriyagami01@gmail.com and they will respond in a reasonable time.\n\n'
                      'Children\n\n'
                      'The Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13.\n\n'
                      'The Application does not address anyone under the age of 13. The Service Provider does not knowingly collect personally identifiable information from children under 13 years of age. In the case the Service Provider discover that a child under 13 has provided personal information, the Service Provider will immediately delete this from their servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact the Service Provider (chouioriyagami01@gmail.com) so that they will be able to take the necessary actions.\n\n'
                      'Security\n\n'
                      'The Service Provider is concerned about safeguarding the confidentiality of your information. The Service Provider provides physical, electronic, and procedural safeguards to protect information the Service Provider processes and maintains.\n\n'
                      'Changes\n\n'
                      'This Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to the Privacy Policy by updating this page with the new Privacy Policy. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.\n\n'
                      'This privacy policy is effective as of 2025-12-28\n\n'
                      'Your Consent\n\n'
                      'By using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by us.\n\n'
                      'Contact Us\n\n'
                      'If you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at chouioriyagami01@gmail.com.\n\n'
                      'This privacy policy page was generated by App Privacy Policy Generator',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Agree Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00B0FF), Color(0xFF2962FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF2962FF,
                          ).withAlpha((255 * 0.4).round()),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final currentContext = context;
                          await _prefsHelper.setPrivacyPolicyAgreed(true);
                          // Request notification permission
                          final notificationService = NotificationService();
                          await notificationService
                              .requestNotificationPermission();
                          if (currentContext.mounted) {
                            Navigator.of(currentContext).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginOptionsScreen(),
                              ),
                            );
                          }
                        },
                        child: Center(
                          child: Text(
                            'Setuju',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Disagree Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Tidak Setuju',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: primaryBlue,
                                  ),
                                ),
                                content: Text(
                                  'Anda harus menyetujui kebijakan privasi untuk menggunakan aplikasi ini.',
                                  style: GoogleFonts.poppins(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Tutup',
                                      style: GoogleFonts.poppins(
                                        color: primaryBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Center(
                          child: Text(
                            'Tidak Setuju',
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
