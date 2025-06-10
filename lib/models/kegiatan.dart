class Kegiatan {
  final int id;
  final String kegiatan;
  final String? catatan;
  final String tanggal;
  final String waktuMulai;
  final String waktuSelesai;
  final String? tempat;

  Kegiatan({
    required this.id,
    required this.kegiatan,
    this.catatan,
    required this.tanggal,
    required this.waktuMulai,
    required this.waktuSelesai,
    this.tempat,
  });

  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    return Kegiatan(
      id: json['id'],
      kegiatan: json['kegiatan'],
      catatan: json['catatan'],
      tanggal: json['tanggal'],
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      tempat: json['tempat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kegiatan': kegiatan,
      'catatan': catatan,
      'tanggal': tanggal,
      'waktu_mulai': waktuMulai,
      'waktu_selesai': waktuSelesai,
      'tempat': tempat,
    };
  }
}
