import 'package:obatin/obat.dart';

// Pastikan import model Obat sudah benar
// import 'package:obatin/obat.dart';

final List<Obat> daftarObat = [
  // --- 1. HIPERTENSI (DARAH TINGGI) & JANTUNG ---
  Obat(
    id: "amlodipine_5",
    nama: "Amlodipine",
    dosis: "5 mg",
    jenis: "Tablet",
    imagePath: "assets/amlodipine.jpg", // Pastikan aset ada
    deskripsi: "Darah Tinggi",
  ),
  Obat(
    id: "amlodipine_10",
    nama: "Amlodipine",
    dosis: "10 mg",
    jenis: "Tablet",
    imagePath: "assets/amlodipine.jpg",
    deskripsi: "Darah Tinggi",
  ),
  Obat(
    id: "captopril_25",
    nama: "Captopril",
    dosis: "25 mg",
    jenis: "Tablet",
    imagePath: "assets/captopril.png",
    deskripsi: "Darah Tinggi",
  ),
  Obat(
    id: "candesartan_8",
    nama: "Candesartan",
    dosis: "8 mg",
    jenis: "Tablet",
    imagePath: "assets/candesartan.jpg",
    deskripsi: "Darah Tinggi",
  ),
  Obat(
    id: "bisoprolol_2_5",
    nama: "Bisoprolol",
    dosis: "2.5 mg",
    jenis: "Tablet",
    imagePath: "assets/bisoprolol.png",
    deskripsi: "Jantung/Tensi",
  ),

  // --- 2. DIABETES (GULA DARAH) ---
  Obat(
    id: "metformin_500",
    nama: "Metformin",
    dosis: "500 mg",
    jenis: "Tablet",
    imagePath: "assets/metformin.jpg",
    deskripsi: "Diabetes",
  ),
  Obat(
    id: "glibenclamide_5",
    nama: "Glibenclamide",
    dosis: "5 mg",
    jenis: "Tablet",
    imagePath: "assets/glibenclamide.png",
    deskripsi: "Diabetes",
  ),

  // --- 3. KOLESTEROL ---
  Obat(
    id: "simvastatin_10",
    nama: "Simvastatin",
    dosis: "10 mg",
    jenis: "Tablet",
    imagePath: "assets/simvastatin.jpg",
    deskripsi: "Kolesterol",
  ),

  // --- 4. NYERI SENDI & ASAM URAT ---
  Obat(
    id: "allopurinol_100",
    nama: "Allopurinol",
    dosis: "100 mg",
    jenis: "Tablet",
    imagePath: "assets/allopurinol.jpg",
    deskripsi: "Asam Urat",
  ),
  Obat(
    id: "paracetamol_500",
    nama: "Paracetamol",
    dosis: "500 mg",
    jenis: "Tablet",
    imagePath: "assets/paracetamol.jpg",
    deskripsi: "Demam/Nyeri",
  ),

  // --- 5. LAMBUNG (GERD/MAAG) ---
  Obat(
    id: "antasida_doen",
    nama: "Antasida Doen",
    dosis: "200 mg",
    jenis: "Tablet Kunyah",
    imagePath: "assets/antasida.jpg",
    deskripsi: "Sakit Maag",
  ),

  // --- 6. VITAMIN & SUPLEMEN ---
  Obat(
    id: "kalsium_500",
    nama: "Kalsium (Calcium)",
    dosis: "500 mg",
    jenis: "Tablet",
    imagePath: "assets/kalsium.jpg",
    deskripsi: "Kesehatan Tulang",
  ),
];
