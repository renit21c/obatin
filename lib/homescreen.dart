import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obatin/obat.dart';
import 'package:obatin/shared_prefs_helper.dart';
import 'dart:async'; // Untuk Timer
import 'package:intl/intl.dart'; // For parsing time strings
import 'list_obat.dart'; // Import variabel global
import 'history_screen.dart';
import 'profile_screen.dart';
import 'user.dart';
import 'history_entry.dart';
import 'notification_service.dart'; // Import notification service
import 'dart:math' as math; // For math.min
import 'package:logging/logging.dart'; // For logging

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger _logger = Logger('HomeScreen');

  User? _user;
  String userName = "Suma";
  List<Obat> jadwalHariIni = [];

  // Variabel Navigasi
  int _selectedIndex = 0;

  // Variabel Auto Slide
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isUserTouching = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startTimerIfNeeded();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // --- LOGIKA UTAMA: OBAT DIMINUM ---
  void _markAsTaken(int index) async {
    final prefsHelper = SharedPreferencesHelper();
    final user = await prefsHelper.getLoggedInUser();

    if (user != null) {
      final obat = jadwalHariIni[index];
      final now = DateTime.now();

      // Cancel the notifications for this medication
      String hashString = obat.id.hashCode.toString();
      int notifId = int.parse(
        hashString.substring(0, math.min(9, hashString.length)),
      );
      if (notifId < 0) notifId = -notifId;
      NotificationService().cancelNotification(notifId);
      NotificationService().cancelNotification(
        notifId + 10000,
      ); // Cancel early notification

      final newHistoryEntry = HistoryEntry(
        id: now.millisecondsSinceEpoch.toString(),
        nama: obat.nama,
        waktu:
            "Diminum: ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
        status: true,
        tanggal: "Hari Ini",
        fullDate: now,
      );

      // Add to history
      user.history.add(newHistoryEntry);
      // Remove the specific taken medication from the user's list
      user.medications.removeWhere((o) => o.id == obat.id);

      // Save the updated user object
      await prefsHelper.updateUser(user);

      // Reload data to update local state and filter for next upcoming
      await _loadUserData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hebat! Obat berhasil diminum."),
          backgroundColor: Color(0xFF00C853),
          duration: Duration(seconds: 2),
        ),
      );

      _startTimerIfNeeded();
    }
  }

  // --- LOGIKA TUNDA OBAT ---
  void _showSnoozeOptions(Obat obat) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Tunda 10 Menit', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  _snoozeMedication(obat, 10);
                },
              ),
              ListTile(
                title: Text('Tunda 20 Menit', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  _snoozeMedication(obat, 20);
                },
              ),
              ListTile(
                title: Text('Tunda 30 Menit', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  _snoozeMedication(obat, 30);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _snoozeMedication(Obat obat, int snoozeMinutes) async {
    final prefsHelper = SharedPreferencesHelper();
    final user = await prefsHelper.getLoggedInUser();

    if (user != null) {
      // Find the index of the original obat in the user's medications list
      int originalObatIndex = user.medications.indexWhere(
        (o) => o.id == obat.id,
      );

      if (originalObatIndex != -1) {
        // Cancel the existing notifications for this obat (both early and main)
        String hashString = obat.id.hashCode.toString();
        int notifId = int.parse(
          hashString.substring(0, math.min(9, hashString.length)),
        );
        if (notifId < 0) notifId = -notifId;
        NotificationService().cancelNotification(notifId);
        NotificationService().cancelNotification(
          notifId + 10000,
        ); // Cancel early notification

        // Calculate the new scheduled time
        DateTime now = DateTime.now();
        DateTime newScheduledTime = now.add(Duration(minutes: snoozeMinutes));

        // Update the obat's jamList
        List<String> newJamList = [
          DateFormat('HH:mm').format(newScheduledTime),
        ];

        // Create a new Obat object with updated jamList (and potentially a new ID if needed, though for snooze, same ID is fine)
        Obat snoozedObat = Obat(
          id: obat.id, // Keep the same ID for snoozed item
          nama: obat.nama,
          dosis: obat.dosis,
          jenis: obat.jenis,
          imagePath: obat.imagePath,
          deskripsi: obat.deskripsi,
          sisa: obat.sisa,
          jamList: newJamList,
          instruksi: obat.instruksi,
        );

        // Replace the old obat with the snoozed one in user's medications
        user.medications[originalObatIndex] = snoozedObat;

        // Save the updated user object
        await prefsHelper.updateUser(user);

        // Reschedule the notifications for the snoozed time (both early and main)
        String newHashString = snoozedObat.id.hashCode.toString();
        int newNotifId = int.parse(
          newHashString.substring(0, math.min(9, newHashString.length)),
        );
        if (newNotifId < 0) newNotifId = -newNotifId;

        // Schedule early notification (10 minutes before snoozed time)
        DateTime earlySnoozedTime = newScheduledTime.subtract(
          const Duration(minutes: 10),
        );
        try {
          await NotificationService().scheduleNotification(
            id: newNotifId + 10000,
            title: "Pengingat Obat",
            body: "Ayo ini udah jadwal kamu minum obat lagi!",
            scheduledDateTime: earlySnoozedTime,
            repeatDaily: true,
          );
        } catch (e) {
          _logger.warning("Failed to schedule snoozed early notification: $e");
        }

        // Schedule main notification
        try {
          await NotificationService().scheduleNotification(
            id: newNotifId,
            title: "Waktunya Minum Obat! 💊 (Ditunda)",
            body:
                "Saatnya minum ${snoozedObat.nama} (${snoozedObat.dosis}) pada jam ${newJamList.first}.",
            scheduledDateTime: newScheduledTime,
            repeatDaily: false, // Snoozed notifications are one-time
          );
        } catch (e) {
          _logger.warning("Failed to schedule snoozed main notification: $e");
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Obat ditunda selama $snoozeMinutes menit."),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );

        // Reload data to update local state and filter for next upcoming
        await _loadUserData();
      }
    }
  }

  void _startTimerIfNeeded() {
    if (_selectedIndex == 0 && jadwalHariIni.length > 1) {
      _startAutoSlide();
    } else {
      _timer?.cancel();
    }
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!_isUserTouching && _selectedIndex == 0 && jadwalHariIni.length > 1) {
        if (_currentPage < jadwalHariIni.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Future<void> _loadUserData() async {
    final user = await SharedPreferencesHelper().getLoggedInUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      String fullName = _user?.namaLansia ?? "Suma";
      userName = fullName.split(' ').first;

      List<Obat> allMedications = _user?.medications ?? [];

      List<Obat> filteredJadwal = [];

      for (var obat in allMedications) {
        if (obat.jamList != null && obat.jamList!.isNotEmpty) {
          try {
            final timeString = obat.jamList!.first;
            final format = DateFormat('HH:mm');
            DateTime? parsedTime;
            try {
              parsedTime = format.parse(timeString);
            } on FormatException {
              // print(
              //   "Warning: FormatException when parsing time string '$timeString' for obat ${obat.nama}: $e. Skipping.",
              // );
            }

            if (parsedTime != null) {
              // The `_markAsTaken` function removes medications once taken,
              // so we don't need an explicit 'isAfter' check here to hide past ones,
              // as they won't be in the list if already taken.
              filteredJadwal.add(obat);
            }
          } catch (e) {
            // Catch any other unexpected errors during processing
            // print("Error processing time for obat ${obat.nama}: $e");
          }
        } else {
          // print(
          //   "Warning: obat ${obat.nama} has null or empty jamList. Skipping.",
          // );
        }
      }

      // Sort the filtered list by scheduled time
      filteredJadwal.sort((a, b) {
        // Ensure that jamList is not null/empty before attempting to parse for sorting
        final String timeStringA =
            a.jamList?.first ?? '00:00'; // Default if unexpected
        final String timeStringB =
            b.jamList?.first ?? '00:00'; // Default if unexpected

        final timeA = DateFormat('HH:mm').parse(timeStringA);
        final timeB = DateFormat('HH:mm').parse(timeStringB);
        return timeA.compareTo(timeB);
      });

      jadwalHariIni = filteredJadwal;

      // Reset page controller if the list changes significantly
      if (_pageController.hasClients && _currentPage >= jadwalHariIni.length) {
        _currentPage = (jadwalHariIni.isEmpty) ? 0 : jadwalHariIni.length - 1;
        _pageController.jumpToPage(_currentPage);
      }
    });
  }

  void _onItemTapped(int index) {
    _loadUserData();
    setState(() {
      _selectedIndex = index;
    });
    _startTimerIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: _buildBodyContent()),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavIcon(Icons.home_filled, 0),
                _buildNavIcon(Icons.access_time_filled, 1),
                _buildNavIcon(Icons.person, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_selectedIndex == 0) {
      return _buildHomeView();
    } else if (_selectedIndex == 1) {
      return HistoryScreen(key: UniqueKey());
    } else {
      return const ProfileScreen();
    }
  }

  Widget _buildHomeView() {
    bool hasJadwal = jadwalHariIni.isNotEmpty;
    final primaryBlue = const Color(0xFF2962FF);
    final darkBlue = const Color(0xFF1A237E);

    return Column(
      children: [
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
          child: hasJadwal
              ? _buildBigCardView(primaryBlue)
              : _buildEmptyState(primaryBlue),
        ),
      ],
    );
  }

  Widget _buildEmptyState(Color primaryBlue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          'Selamat Datang, $userName!',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF304FFE),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Tambahkan Obat Kamu',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: primaryBlue,
          ),
        ),
        const SizedBox(height: 15), // sebelumnya 10 + Row, diganti jadi 15 agar proporsional
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, const Color(0xFF00B0FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withAlpha((255 * 0.4).round()),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListObatScreen(),
                  ),
                );
                _loadUserData();
              },
              child: const Center(
                child: Icon(Icons.add, size: 120, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'Semua obat sudah diminum!\nTetap sehat ya.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16, color: primaryBlue),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildBigCardView(Color primaryBlue) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: Listener(
            onPointerDown: (_) {
              setState(() => _isUserTouching = true);
              _timer?.cancel();
            },
            onPointerUp: (_) {
              setState(() => _isUserTouching = false);
              _startTimerIfNeeded();
            },
            onPointerCancel: (_) {
              setState(() => _isUserTouching = false);
              _startTimerIfNeeded();
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: jadwalHariIni.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return _buildBigCard(jadwalHariIni[index], index);
              },
            ),
          ),
        ),
        if (jadwalHariIni.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(jadwalHariIni.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                width: _currentPage == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentPage == index
                      ? const Color(0xFF1A237E)
                      : Colors.grey.withAlpha((255 * 0.5).round()),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildBigCard(Obat obat, int index) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Text(
              obat.nama,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2962FF),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "${obat.jenis} • ${obat.dosis} • ${obat.deskripsi}",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2962FF), Color(0xFF00B0FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlpha((255 * 0.4).round()),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        obat.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, stack) => const Icon(
                          Icons.medication,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sisa: ${obat.sisa}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        obat.jamList?.first ??
                            '', // Display the first scheduled time
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // --- AREA INSTRUKSI MAKAN ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((255 * 0.2).round()),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withAlpha((255 * 0.5).round()),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.restaurant,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          obat.instruksi ??
                              '', // <--- INI AKAN MENAMPILKAN PILIHAN USER
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildActionButton(
                    label: "Tunda",
                    color: const Color(0xFFD50000),
                    onTap: () => _showSnoozeOptions(obat),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: _buildActionButton(
                    icon: Icons.add,
                    color: const Color(0xFF2962FF),
                    isGradient: true,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListObatScreen(),
                        ),
                      );
                      _loadUserData();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildActionButton(
              label: "Minum",
              color: const Color(0xFF00C853),
              height: 70,
              fontSize: 28,
              onTap: () => _markAsTaken(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    String? label,
    IconData? icon,
    required Color color,
    required VoidCallback onTap,
    bool isGradient = false,
    double height = 60,
    double fontSize = 24,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isGradient ? null : color,
        gradient: isGradient
            ? const LinearGradient(
                colors: [Color(0xFF2962FF), Color(0xFF00B0FF)],
              )
            : null,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha((255 * 0.3).round()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Center(
            child: label != null
                ? Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : Icon(icon, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2962FF) : const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(
                (255 * (isActive ? 0.3 : 0.1)).round(),
              ),
              blurRadius: isActive ? 15 : 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: isActive ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Icon(icon, color: Colors.white, size: 35),
      ),
    );
  }
}
