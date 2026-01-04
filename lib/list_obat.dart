import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obatin/obat.dart';
import 'atur_konsumsi.dart'; // Pastikan import ini ada
import 'obat_data.dart'; // Import database obat

class ListObatScreen extends StatefulWidget {
  const ListObatScreen({super.key});

  @override
  State<ListObatScreen> createState() => _ListObatScreenState();
}

class _ListObatScreenState extends State<ListObatScreen> {
  final Set<int> _selectedIndices = {};

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  Future<void> _navigateToAturKonsumsi(Obat obat) async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AturKonsumsiScreen(
          obat: obat,
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    if (!mounted) return;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        ),
        content: Text(
          "Semua obat berhasil diatur!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(ctx).popUntil((route) => route.isFirst);
              },
              child: Text(
                "Selesai",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Floating Action Button (Next)
      floatingActionButton: Container(
        height: 70,
        width: 70,
        margin: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          onPressed: () async {
            if (_selectedIndices.isEmpty) {
              _showErrorDialog(context);
            } else {
              final List<Obat> obatTerpilih = _selectedIndices
                  .map((index) => daftarObat[index])
                  .toList();

              for (final obat in obatTerpilih) {
                if (!mounted) return;
                await _navigateToAturKonsumsi(obat);
              }
              
              await _showSuccessDialog();
            }
          },
          backgroundColor: const Color(0xFF1A237E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 35),
        ),
      ),

      body: Column(
        children: [
          // Header Biru
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF1A237E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Center(
                  child: Text(
                    'obatin.',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // List Obat
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemCount: daftarObat.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final isSelected = _selectedIndices.contains(index);
                final obat = daftarObat[index];

                return GestureDetector(
                  onTap: () => _toggleSelection(index),
                  child: _buildObatCard(obat: obat, isSelected: isSelected),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper Kartu Obat
  Widget _buildObatCard({required Obat obat, required bool isSelected}) {
    final List<Color> gradientColors = isSelected
        ? [const Color(0xFF009688), const Color(0xFF26A69A)]
        : [const Color(0xFF2962FF), const Color(0xFF00B0FF)];

    final Color innerBoxColor = isSelected
        ? const Color(0xFF69F0AE)
        : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 260,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.green.withAlpha((255 * 0.3).round())
                : Colors.blue.withAlpha((255 * 0.3).round()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // KOTAK GAMBAR
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: innerBoxColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: isSelected
                  ? Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C853),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 45,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        obat.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.medication,
                            color: Colors.grey,
                            size: 80,
                          );
                        },
                      ),
                    ),
            ),
          ),

          // NAMA OBAT
          Text(
            obat.nama,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // DOSIS & JENIS & DESKRIPSI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "${obat.jenis} • ${obat.dosis} • ${obat.deskripsi}",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withAlpha((255 * 0.9).round()),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                margin: const EdgeInsets.only(top: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Kamu belum\nmenambahkan obat!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2962FF), Color(0xFF00B0FF)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () => Navigator.pop(context),
                          child: Center(
                            child: Text(
                              'Okay!',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
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
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error,
                    color: Colors.redAccent,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
