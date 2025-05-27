import 'package:flutter/material.dart';
import 'edit_jadwal_page.dart';
import 'tambah_jadwal_page.dart';

// Halaman utama untuk menampilkan daftar jadwal
class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data jadwal 
    List<Map<String, String>> jadwal = [
      {
        'nama': 'Belajar Flutter',
        'hari': 'Senin',
        'waktuMulai': '08:00',
        'waktuSelesai': '10:00',
        'kategori': 'Membaca',
        'deskripsi': 'Fokus membuat tampilan Flutter',
      },
      {
        'nama': 'Meeting Tim',
        'hari': 'Selasa',
        'waktuMulai': '10:00',
        'waktuSelesai': '12:00',
        'kategori': 'Diskusi',
        'deskripsi': 'Membahas proyek dan update tugas',
      },
      {
        'nama': 'Olahraga',
        'hari': 'Rabu',
        'waktuMulai': '07:00',
        'waktuSelesai': '08:00',
        'kategori': 'Kesehatan',
        'deskripsi': 'Jogging di taman sekitar rumah',
      },
      {
        'nama': 'Belajar Bahasa Inggris',
        'hari': 'Kamis',
        'waktuMulai': '09:00',
        'waktuSelesai': '11:00',
        'kategori': 'Belajar',
        'deskripsi': 'Mempelajari grammar dan vocabulary',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Care Rhythm - Jadwal"),
        backgroundColor: const Color(0xFF7A3CFF), // Warna ungu branding
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromARGB(128, 138, 43, 226)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Dropdown untuk memilih hari (belum difungsikan)
                DropdownButton<String>(
                  hint: const Text("Pilih Hari"),
                  items:
                      const [
                        'Senin',
                        'Selasa',
                        'Rabu',
                        'Kamis',
                        'Jumat',
                        'Sabtu',
                        'Minggu',
                      ].map((hari) {
                        return DropdownMenuItem(value: hari, child: Text(hari));
                      }).toList(),
                  onChanged: (_) {}, // Tidak ada aksi saat hari dipilih
                ),
                const Spacer(), // Mendorong tombol ke kanan
                // Tombol untuk menambahkan jadwal baru
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A3CFF),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TambahJadwalPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Jadwal"),
                ),
              ],
            ),
            const SizedBox(height: 16), // Spasi antar elemen
            // ListView untuk menampilkan semua jadwal
            Expanded(
              child: ListView.builder(
                itemCount: jadwal.length,
                itemBuilder: (context, index) {
                  var data = jadwal[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Informasi detail kegiatan
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['hari']!,
                                  style: const TextStyle(
                                    color: Color(0xFF7A3CFF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data['nama']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Kategori: ${data['kategori']}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Text("Deskripsi: ${data['deskripsi']}"),
                                Text(
                                  "${data['waktuMulai']} - ${data['waktuSelesai']}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // Tombol untuk pindah ke halaman EditJadwalPage (hanya tampilan)
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: const Color(0xFF7A3CFF),
                            onPressed: () {
                              // Navigasi ke halaman EditJadwalPage (versi tampilan saja)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditJadwalPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
