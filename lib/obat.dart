class Obat {
  String id;
  final String nama;
  final String dosis;
  final String jenis;
  final String imagePath;
  final String deskripsi;
  String? sisa;
  List<String>? jamList;
  String? instruksi;

  Obat({
    required this.id,
    required this.nama,
    required this.dosis,
    required this.jenis,
    required this.imagePath,
    required this.deskripsi,
    this.sisa,
    this.jamList,
    this.instruksi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'dosis': dosis,
      'jenis': jenis,
      'imagePath': imagePath,
      'deskripsi': deskripsi,
      'sisa': sisa,
      'jamList': jamList,
      'instruksi': instruksi,
    };
  }

  factory Obat.fromMap(Map<String, dynamic> map) {
    return Obat(
      id: map['id'],
      nama: map['nama'],
      dosis: map['dosis'],
      jenis: map['jenis'],
      imagePath: map['imagePath'],
      deskripsi: map['deskripsi'],
      sisa: map['sisa'],
      jamList: (map['jamList'] as List?)?.map((e) => e as String).toList(),
      instruksi: map['instruksi'],
    );
  }
}
