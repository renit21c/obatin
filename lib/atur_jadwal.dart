import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:obatin/shared_prefs_helper.dart';
import 'obat.dart'; // Import model Obat
import 'notification_service.dart';

class AturJadwalScreen extends StatefulWidget {
  final Obat currentObat;

  // Data dari Step 1
  final int stok;
  final int durasi;

  const AturJadwalScreen({
    super.key,
    required this.currentObat,
    required this.stok,
    required this.durasi,
  });

  @override
  State<AturJadwalScreen> createState() => _AturJadwalScreenState();
}

class _AturJadwalScreenState extends State<AturJadwalScreen> {
  final Logger _logger = Logger('AturJadwalScreen');

  // State Form Step 2
  int _frekuensi = 1; // 1x, 2x, 3x, 4x
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  int _instruksiMakan = 2; // 1=Sebelum, 2=Sesudah, 3=Bersamaan

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF2962FF);
    final darkBlue = const Color(0xFF1A237E);

    return Scaffold(
      backgroundColor: Colors.white,

      // Tombol Next (Lanjut ke Obat Berikutnya atau Selesai)
      floatingActionButton: Container(
        height: 70,
        width: 70,
        margin: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          onPressed: _handleFinishOrNext,
          backgroundColor: darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 35),
        ),
      ),

      body: Column(
        children: [
          // Header Biru
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

                  // Nama Obat (Subtitle)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: RichText(
                      text: TextSpan(
                        text: 'Jadwal untuk ',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: widget.currentObat.nama,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 1. Berapa kali sehari?
                  Text(
                    'Berapa kali sehari?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFrekuensiBtn(1, "1x"),
                      _buildFrekuensiBtn(2, "2x"),
                      _buildFrekuensiBtn(3, "3x"),
                      _buildFrekuensiBtn(4, "4x"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 2. Jam berapa?
                  Text(
                    'Jam berapa?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: _pickTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryBlue, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}", // Format 10:00
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_circle,
                            color: primaryBlue,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 3. Instruksi minum
                  Text(
                    'Instruksi minum',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ToggleButtons(
                    isSelected: [
                      _instruksiMakan == 1,
                      _instruksiMakan == 2,
                      _instruksiMakan == 3,
                    ],
                    onPressed: (index) {
                      setState(() {
                        _instruksiMakan = index + 1;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    color: primaryBlue,
                    fillColor: primaryBlue,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Sebelum'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Sesudah'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Bersamaan'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80), // Space untuk FAB
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to generate notification times
  List<TimeOfDay> _generateNotificationTimes(
    int frequency,
    TimeOfDay initialTime,
  ) {
    List<TimeOfDay> times = [];

    for (int i = 0; i < frequency; i++) {
      int newHour =
          (initialTime.hour + (6 * i)) %
          24; // Add 6 hours for each subsequent dose
      times.add(TimeOfDay(hour: newHour, minute: initialTime.minute));
    }

    // Sort times chronologically
    times.sort((a, b) {
      final aTotalMinutes = a.hour * 60 + a.minute;
      final bTotalMinutes = b.hour * 60 + b.minute;
      return aTotalMinutes.compareTo(bTotalMinutes);
    });

    return times;
  }

  // LOGIKA UTAMA: NEXT atau FINISH
  void _handleFinishOrNext() async {
    // 1. TERJEMAHKAN PILIHAN RADIO BUTTON KE TEKS
    String teksInstruksi = "Sesudah makan"; // Default
    if (_instruksiMakan == 1) {
      teksInstruksi = "Sebelum makan";
    } else if (_instruksiMakan == 2) {
      teksInstruksi = "Sesudah makan";
    } else if (_instruksiMakan == 3) {
      teksInstruksi = "Bersamaan makan";
    }

    final prefsHelper = SharedPreferencesHelper();
    final user = await prefsHelper.getLoggedInUser();

    if (!mounted) return;

    if (user != null) {
      final List<TimeOfDay> scheduledTimes = _generateNotificationTimes(
        _frekuensi,
        _selectedTime,
      );

      for (int i = 0; i < scheduledTimes.length; i++) {
        final TimeOfDay time = scheduledTimes[i];
        final String formattedTime =
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
        // Generate a unique ID for each scheduled dose
        final String uniqueId =
            "${widget.currentObat.id}-${time.hour}-${time.minute}-${DateTime.now().millisecondsSinceEpoch + i}";

        final Obat newObat = Obat(
          id: uniqueId,
          nama: widget.currentObat.nama,
          jenis: widget.currentObat.jenis,
          dosis: widget.currentObat.dosis,
          deskripsi: widget.currentObat.deskripsi,
          imagePath: widget.currentObat.imagePath,
          sisa:
              "${widget.stok} Butir", // Each individual dose object will have the total stock
          jamList: [formattedTime], // Only the specific time for this dose
          instruksi: teksInstruksi,
        );

        // Add this specific scheduled dose as a new medication entry
        await prefsHelper.addMedication(user.namaLansia, newObat);

        if (!mounted) return;

        // Schedule notification for this specific dose - use simpler ID generation
        // Create a unique but manageable ID based on medicine ID and time
        int baseId =
            widget.currentObat.id.hashCode.abs() %
            10000; // Keep base ID under 10000
        int timeId = time.hour * 100 + time.minute; // HHMM format
        int notifId =
            baseId + timeId + (i * 1000); // Add index offset to avoid conflicts
        notifId = notifId % 2147483647; // Ensure within int range

        // Construct base DateTime for the schedule
        final now = DateTime.now();
        DateTime scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        // Schedule early notification (10 minutes before)
        DateTime earlyTime = scheduledTime.subtract(
          const Duration(minutes: 10),
        );
        int earlyNotifId = notifId + 10000; // Unique ID for early notification

        _logger.info(
          "Scheduling early notification for ${widget.currentObat.nama} at $earlyTime (ID: $earlyNotifId)",
        );
        NotificationService().scheduleNotification(
          id: earlyNotifId,
          title: "Pengingat Obat - ${widget.currentObat.nama}",
          body: "Ayo ini udah jadwal kamu minum obat lagi!",
          scheduledDateTime: earlyTime,
          repeatDaily: true,
        );

        // Schedule main notification (at exact time)
        _logger.info(
          "Scheduling main notification for ${widget.currentObat.nama} at $scheduledTime (ID: $notifId)",
        );
        NotificationService().scheduleNotification(
          id: notifId,
          title: "Waktunya Minum Obat! 💊 - ${widget.currentObat.nama}",
          body:
              "Saatnya minum ${widget.currentObat.nama} (${widget.currentObat.dosis}) pada jam $formattedTime.",
          scheduledDateTime: scheduledTime,
          repeatDaily: false,
        );
      }
    }
    Navigator.of(context).pop();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _buildFrekuensiBtn(int value, String label) {
    bool isSelected = _frekuensi == value;
    return GestureDetector(
      onTap: () => setState(() => _frekuensi = value),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2962FF) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF2962FF), width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withAlpha((255 * 0.4).round()),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF2962FF),
          ),
        ),
      ),
    );
  }
}
