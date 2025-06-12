class Pencapaian {
  final int? id;
  final String nama;
  final int jumlah;
  final int target;
  final String? kategori;
  final String waktuPencapaian;
  final int? userId;

  Pencapaian({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.target,
    this.kategori,
    required this.waktuPencapaian,
    this.userId,
  });

  factory Pencapaian.fromJson(Map<String, dynamic> json) {
    return Pencapaian(
      id: json['id'],
      nama: json['nama'],
      jumlah: json['jumlah'],
      target: json['target'],
      kategori: json['kategori'],
      waktuPencapaian: json['waktu_pencapaian'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jumlah': jumlah,
      'target': target,
      'kategori': kategori,
      'waktu_pencapaian': waktuPencapaian,
      'user_id': userId,
    };
  }
}
