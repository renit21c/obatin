import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obatin/obat.dart';
import 'atur_jadwal.dart'; // <--- Import Step 2

class AturKonsumsiScreen extends StatefulWidget {
  final Obat obat;

  const AturKonsumsiScreen({super.key, required this.obat});

  @override
  State<AturKonsumsiScreen> createState() => _AturKonsumsiScreenState();
}

class _AturKonsumsiScreenState extends State<AturKonsumsiScreen> {
  // State Form
  int _stokCount = 10;
  int _durasiHari = 5;
  int _tipeDurasi = 1;

  @override
  Widget build(BuildContext context) {
    final Obat obatSekarang = widget.obat;
    final primaryBlue = const Color(0xFF2962FF);
    final darkBlue = const Color(0xFF1A237E);

    return Scaffold(
      backgroundColor: Colors.white,

      // Floating Action Button (Next ke Step 2)
      floatingActionButton: Container(
        height: 70,
        width: 70,
        margin: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          onPressed: _goToStepTwo, // Pindah ke Step 2
          backgroundColor: darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 35),
        ),
      ),

      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: Center(
              child: Text(
                'obatin.',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'atur konsumsi obat',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: primaryBlue,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Stok & Durasi untuk ',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: obatSekarang.nama,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Stok
                  Text(
                    'Berapa stok obat-mu?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildCounterButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (_stokCount > 0) setState(() => _stokCount--);
                        },
                      ),
                      const SizedBox(width: 15),
                      Container(
                        width: 60,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        child: Text(
                          '$_stokCount',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'butir',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 15),
                      _buildCounterButton(
                        icon: Icons.add,
                        onTap: () => setState(() => _stokCount++),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Durasi
                  Text(
                    'Sampai kapan?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ToggleButtons(
                    isSelected: [
                      _tipeDurasi == 1,
                      _tipeDurasi == 2,
                    ],
                    onPressed: (index) {
                      setState(() {
                        _tipeDurasi = index + 1;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    color: primaryBlue,
                    fillColor: primaryBlue,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Terus menerus'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Jangka waktu'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_tipeDurasi == 2)
                    Row(
                      children: [
                        _buildCounterButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (_durasiHari > 1) setState(() => _durasiHari--);
                          },
                        ),
                        const SizedBox(width: 15),
                        Container(
                          width: 60,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          child: Text(
                            '$_durasiHari',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'hari',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 15),
                        _buildCounterButton(
                          icon: Icons.add,
                          onTap: () => setState(() => _durasiHari++),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // LOGIKA PINDAH KE STEP 2
  void _goToStepTwo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AturJadwalScreen(
          currentObat: widget.obat,
          stok: _stokCount,
          durasi: _durasiHari,
        ),
      ),
    );
    if (!mounted) return;
    // Setelah AturJadwalScreen di-pop, pop juga layar ini
    Navigator.of(context).pop();
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2962FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha((255 * 0.3).round()),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
