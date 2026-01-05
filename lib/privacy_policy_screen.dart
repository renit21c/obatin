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
                      'Kebijakan Privasi\n\n'
                          'Kebijakan privasi ini berlaku untuk aplikasi Obatin (selanjutnya disebut "Aplikasi") pada perangkat mobile yang dibuat oleh Obat-Team (selanjutnya disebut "Penyedia Layanan") sebagai layanan gratis. Layanan ini dimaksudkan untuk digunakan "SEBAGAIMANA ADANYA".\n\n'
                          'Pengumpulan dan Penggunaan Informasi\n\n'
                          'Aplikasi mengumpulkan informasi ketika Anda mengunduh dan menggunakannya. Informasi ini dapat mencakup:\n'
                          '- Alamat IP perangkat Anda\n'
                          '- Halaman aplikasi yang Anda kunjungi, waktu dan tanggal kunjungan, serta lama penggunaan\n'
                          '- Sistem operasi yang digunakan pada perangkat Anda\n\n'
                          'Aplikasi juga dapat mengumpulkan lokasi perangkat Anda, yang membantu Penyedia Layanan menentukan lokasi geografis perkiraan dan digunakan untuk:\n'
                          '- Layanan berbasis lokasi\n'
                          '- Analisis dan peningkatan kinerja aplikasi\n'
                          '- Pengoptimalan layanan melalui pihak ketiga\n\n'
                          'Penyedia Layanan dapat menggunakan informasi yang Anda berikan untuk menghubungi Anda dari waktu ke waktu guna memberikan informasi penting, pemberitahuan, atau promosi.\n\n'
                          'Akses Pihak Ketiga\n\n'
                          'Data anonim dapat dibagikan secara berkala kepada layanan pihak ketiga untuk membantu meningkatkan aplikasi dan layanan. Kami tidak akan membagikan data pribadi Anda tanpa persetujuan.\n\n'
                          'Hak Pengguna\n\n'
                          'Anda dapat menghentikan pengumpulan informasi dengan mudah dengan menghapus aplikasi. Anda juga dapat meminta penghapusan data dengan menghubungi kami.\n\n'
                          'Anak-Anak\n\n'
                          'Aplikasi tidak ditujukan untuk anak di bawah usia 13 tahun. Kami tidak secara sadar mengumpulkan data pribadi dari anak-anak. Jika Anda adalah orang tua/wali dan mengetahui anak Anda memberikan data pribadi, silakan hubungi kami agar dapat segera dihapus.\n\n'
                          'Keamanan\n\n'
                          'Kami berkomitmen menjaga kerahasiaan informasi Anda dengan langkah fisik, elektronik, dan prosedural.\n\n'
                          'Perubahan\n\n'
                          'Kebijakan privasi ini dapat diperbarui dari waktu ke waktu. Perubahan akan diumumkan melalui aplikasi.\n\n'
                          'Tanggal Berlaku: 28 Desember 2025\n\n'
                          'Persetujuan Anda\n\n'
                          'Dengan menggunakan aplikasi, Anda menyetujui pemrosesan informasi sesuai kebijakan privasi ini.\n\n'
                          'Kontak Kami\n\n'
                          'Jika ada pertanyaan terkait privasi, silakan hubungi kami di: support@obatin.com.\n',
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
