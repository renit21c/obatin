import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obatin/shared_prefs_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();

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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),

              const SizedBox(height: 20),

              Text(
                'Lupa Password',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: primaryBlue,
                ),
              ),

              const SizedBox(height: 30),

              _buildCustomTextField(
                controller: _usernameController,
                hintText: "Masukkan Nama Lansia",
                icon: Icons.person_outline,
                color: primaryBlue,
              ),

              const SizedBox(height: 20),

              _buildCustomTextField(
                controller: _newPasswordController,
                hintText: "Masukkan Password Baru",
                icon: Icons.vpn_key_outlined,
                color: primaryBlue,
                isPassword: true,
              ),

              const SizedBox(height: 40),

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
                      String username = _usernameController.text;
                      String newPassword = _newPasswordController.text;

                      final messenger = ScaffoldMessenger.of(currentContext);

                      if (username.isEmpty || newPassword.isEmpty) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Nama dan password baru harus diisi!',
                            ),
                          ),
                        );
                        return;
                      }
                      final success = await _prefsHelper.updatePassword(
                        username,
                        newPassword,
                      );

                      if (success) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Password berhasil diubah!'),
                          ),
                        );
                        if (currentContext.mounted) {
                          Navigator.of(currentContext).pop();
                        }
                      } else {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Pengguna tidak ditemukan!'),
                          ),
                        );
                      }
                    },
                    child: Center(
                      child: Text(
                        'Ubah Password',
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

              const SizedBox(height: 100),

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
        obscureText: isPassword,
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
