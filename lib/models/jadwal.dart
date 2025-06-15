class Jadwal {
  final int id;
  final int? userId;
  final String namaJadwal;
  final String kategori;
  final String waktuMulai;
  final String waktuSelesai;
  final List<String> hari;
  final String? catatan;

  Jadwal({
    required this.id,
    this.userId,
    required this.namaJadwal,
    required this.kategori,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.hari,
    this.catatan,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    // Pastikan parsing hari dari string ke List<String>
    final hariRaw = json['hari'];
    List<String> hariList;
    if (hariRaw is List) {
      hariList = List<String>.from(hariRaw);
    } else if (hariRaw is String) {
      hariList = hariRaw.split(',').map((e) => e.trim()).toList();
    } else {
      hariList = [];
    }
    return Jadwal(
      id: json['id'],
      userId: json['user_id'],
      namaJadwal: json['nama_jadwal'],
      kategori: json['kategori'],
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      hari: hariList,
      catatan: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nama_jadwal': namaJadwal,
      'kategori': kategori,
      'waktu_mulai': waktuMulai,
      'waktu_selesai': waktuSelesai,
      // Always send as comma-separated string for backend compatibility
      'hari': hari.join(','),
      'catatan': catatan,
    };
  }
}
