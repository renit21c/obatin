class HistoryEntry {
  String id;
  final String nama;
  final String waktu;
  final bool status;
  final String tanggal;
  final DateTime fullDate;

  HistoryEntry({
    required this.id,
    required this.nama,
    required this.waktu,
    required this.status,
    required this.tanggal,
    required this.fullDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'waktu': waktu,
      'status': status,
      'tanggal': tanggal,
      'fullDate': fullDate.toIso8601String(),
    };
  }

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      id: map['id'],
      nama: map['nama'],
      waktu: map['waktu'],
      status: map['status'],
      tanggal: map['tanggal'],
      fullDate: DateTime.parse(map['fullDate']),
    );
  }
}
