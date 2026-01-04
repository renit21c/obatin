import 'obat.dart';
import 'history_entry.dart';

class User {
  final String namaPerawat;
  final String nomorPerawat;
  final String namaLansia;
  final String password;
  String umur;
  String prioritasPenyakit;
  String emergencyNumber;
  String? profilePicturePath;
  List<Obat> medications;
  List<HistoryEntry> history;

  User({
    required this.namaPerawat,
    required this.nomorPerawat,
    required this.namaLansia,
    required this.password,
    this.umur = "65",
    this.prioritasPenyakit = "Hipertensi, Diabetes",
    this.emergencyNumber = "628123456789",
    this.profilePicturePath,
    this.medications = const [],
    this.history = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'namaPerawat': namaPerawat,
      'nomorPerawat': nomorPerawat,
      'namaLansia': namaLansia,
      'password': password,
      'umur': umur,
      'prioritasPenyakit': prioritasPenyakit,
      'emergencyNumber': emergencyNumber,
      'profilePicturePath': profilePicturePath,
      'medications': medications.map((m) => m.toMap()).toList(),
      'history': history.map((h) => h.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      namaPerawat: map['namaPerawat'],
      nomorPerawat: map['nomorPerawat'],
      namaLansia: map['namaLansia'],
      password: map['password'],
      umur: map['umur'],
      prioritasPenyakit: map['prioritasPenyakit'],
      emergencyNumber: map['emergencyNumber'],
      profilePicturePath: map['profilePicturePath'],
      medications: (map['medications'] as List)
          .map((m) => Obat.fromMap(m))
          .toList(),
      history: (map['history'] as List)
          .map((h) => HistoryEntry.fromMap(h))
          .toList(),
    );
  }
}
