import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obatin/shared_prefs_helper.dart';
import 'package:obatin/user.dart';
import 'masuk.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;

  // Controller untuk mengambil teks input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nomorPerawatController = TextEditingController();
  final TextEditingController _namaLansiaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final prefsHelper = SharedPreferencesHelper();

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF2962FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: primaryBlue, size: 28),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),

              const SizedBox(height: 20),

              Text(
                'Daftar',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: primaryBlue,
                ),
              ),

              const SizedBox(height: 30),

              // Form Input
              _buildCustomTextField(
                controller: _nameController,
                hintText: "Masukkan Nama Perawat",
                icon: Icons.person_outline,
                color: primaryBlue,
              ),
              const SizedBox(height: 20),
              _buildCustomTextField(
                controller: _nomorPerawatController,
                hintText: "Masukkan Nomor Perawat",
                icon: Icons.phone_outlined,
                color: primaryBlue,
              ),
              const SizedBox(height: 20),
              _buildCustomTextField(
                controller: _namaLansiaController,
                hintText: "Masukkan Nama Lansia",
                icon: Icons.person_search_outlined,
                color: primaryBlue,
              ),
              const SizedBox(height: 20),
              _buildCustomTextField(
                controller: _passwordController,
                hintText: "Masukkan Password",
                icon: Icons.vpn_key_outlined,
                isPassword: true,
                color: primaryBlue,
              ),

              const SizedBox(height: 40),

              // Tombol Daftar
              Center(
                child: Container(
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
                        // Validasi input
                        if (_nameController.text.isEmpty ||
                            _nomorPerawatController.text.isEmpty ||
                            _namaLansiaController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Semua field harus diisi!'),
                            ),
                          );
                          return;
                        }

                        // Format nomor telepon ke +62
                        String formattedNumber = _nomorPerawatController.text;
                        String digitsOnly =
                            formattedNumber.replaceAll(RegExp(r'\D'), '');

                        if (digitsOnly.startsWith('0')) {
                          digitsOnly = '62${digitsOnly.substring(1)}';
                        } else if (digitsOnly.isNotEmpty &&
                            !digitsOnly.startsWith('62')) {
                          digitsOnly = '62$digitsOnly';
                        }

                        if (digitsOnly.isNotEmpty) {
                          formattedNumber = '+$digitsOnly';
                        }

                        // Buat objek User
                        final user = User(
                          namaPerawat: _nameController.text,
                          nomorPerawat: formattedNumber,
                          namaLansia: _namaLansiaController.text,
                          password: _passwordController.text,
                          emergencyNumber: formattedNumber,
                        );

                        // Simpan ke database
                        final result = await prefsHelper.saveUser(user);

                        // Tampilkan notifikasi berhasil
                        if (context.mounted) {
                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Pendaftaran berhasil! Silakan masuk.',
                                ),
                              ),
                            );

                            // Pindah ke halaman login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MasukScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nama lansia sudah ada!'),
                              ),
                            );
                          }
                        }
                      },
                      child: Center(
                        child: Text(
                          'Daftar',
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
              ),

              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MasukScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: GoogleFonts.poppins(
                        color: primaryBlue,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Masuk',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A237E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              Center(
                child: Text(
                  'obatin.',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A237E),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String hintText,
    required IconData icon,
    required Color color,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    const double borderRadius = 12.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha((255 * 0.05).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: color.withAlpha((255 * 0.6).round()),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Icon(icon, color: color),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 50),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: color.withAlpha((255 * 0.6).round()),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: color, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: color, width: 2.0),
          ),
        ),
      ),
    );
  }
}
