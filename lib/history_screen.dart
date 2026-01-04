import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obatin/shared_prefs_helper.dart';
import 'package:obatin/history_entry.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryEntry> riwayatList = [];

  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  Future<void> _getHistory() async {
    final user = await SharedPreferencesHelper().getLoggedInUser();
    if (!mounted) return;
    if (user != null) {
      setState(() {
        riwayatList = user.history;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = const Color(0xFF1A237E);

    return Column(
      children: [
        // --- HEADER ---
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
          child: Column(
            children: [
              Text(
                'Riwayat',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Performa 7 Hari Terakhir',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // 2. GRAFIK MINGGUAN DINAMIS
              _buildWeeklyGraphCard(),

              const SizedBox(height: 25),

              Text(
                "Aktivitas Terakhir (Geser hapus)",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 15),

              // 3. LIST RIWAYAT DENGAN FITUR HAPUS
              if (riwayatList.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.history, size: 50, color: Colors.grey[300]),
                        Text(
                          "Belum ada obat diminum",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...riwayatList.map((item) {
                  return _buildDismissibleItem(item);
                }),
            ],
          ),
        ),
      ],
    );
  }

  // === LOGIC MENGHITUNG GRAFIK 7 HARI ===
  Widget _buildWeeklyGraphCard() {
    // 1. Tentukan 7 hari terakhir dari hari ini
    DateTime today = DateTime.now();
    List<Widget> bars = [];

    // Variabel hitung total konsumsi minggu ini
    int totalKonsumsiMingguIni = 0;

    // Loop dari 6 hari lalu sampai hari ini (0)
    for (int i = 6; i >= 0; i--) {
      DateTime targetDate = today.subtract(Duration(days: i));

      // 2. Hitung jumlah obat diminum pada tanggal tersebut
      int count = riwayatList.where((item) {
        DateTime itemDate = item.fullDate;
        return itemDate.year == targetDate.year &&
            itemDate.month == targetDate.month &&
            itemDate.day == targetDate.day;
      }).length;

      totalKonsumsiMingguIni += count;

      // 3. Tentukan Label Hari (Sen, Sel, Rab...)
      String dayLabel = _getDayName(targetDate.weekday);

      // Highlight hari ini
      bool isToday = i == 0;

      // 4. Masukkan ke list grafik
      bars.add(_buildBar(dayLabel, count, isToday));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha((255 * 0.1).round()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Konsumsi",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "$totalKonsumsiMingguIni Obat",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFF00C853),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Render Baris Grafik
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: bars,
          ),
        ],
      ),
    );
  }

  // Helper Translate Hari
  String _getDayName(int weekday) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[weekday - 1];
  }

  // Helper Render Satu Batang
  Widget _buildBar(String day, int count, bool isToday) {
    // Normalisasi tinggi batang (Misal max harian 5 obat = 100% tinggi)
    // Jika count 0, tinggi minimal tetap ada dikit
    double maxMedsPerDay = 5.0;
    double heightFactor = (count / maxMedsPerDay).clamp(0.0, 1.0);
    double barHeight = heightFactor * 80; // Max tinggi 80 pixel
    if (count > 0 && barHeight < 10) {
      barHeight = 10; // Biar kelihatan dikit kalo ada isinya
    }

    return Column(
      children: [
        // Angka di atas batang (opsional, muncul kalo ada isinya)
        if (count > 0)
          Text(
            count.toString(),
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

        const SizedBox(height: 4),

        // Batang
        Container(
          width: 12,
          height: barHeight == 0 ? 4 : barHeight, // Kalau 0 kasih titik kecil
          decoration: BoxDecoration(
            // Hari ini = Biru Tua, Hari Lain (ada isi) = Biru Terang, Kosong = Abu
            color: count > 0
                ? (isToday ? const Color(0xFF1A237E) : const Color(0xFF2962FF))
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),

        // Label Hari
        Text(
          day,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? const Color(0xFF1A237E) : Colors.grey,
          ),
        ),
      ],
    );
  }

  // === WIDGET SWIPE DELETE ===
  Widget _buildDismissibleItem(HistoryEntry item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline, color: Colors.red, size: 30),
      ),
      onDismissed: (direction) async {
        final user = await SharedPreferencesHelper().getLoggedInUser();
        if (user != null) {
          setState(() {
            riwayatList.remove(item);
            user.history = riwayatList;
            SharedPreferencesHelper().updateUser(user);
          });
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${item.nama} dihapus dari riwayat",
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF1A237E),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: _buildHistoryCard(item),
    );
  }

  // Kartu Detail Riwayat
  Widget _buildHistoryCard(HistoryEntry item) {
    bool status = item.status;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((255 * 0.05).round()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: status ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              status ? Icons.check : Icons.close,
              color: status ? const Color(0xFF00C853) : const Color(0xFFD50000),
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF1A237E),
                  ),
                ),
                Text(
                  "${item.tanggal} • ${item.waktu}",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
