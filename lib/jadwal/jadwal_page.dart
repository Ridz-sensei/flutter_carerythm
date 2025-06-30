import 'package:flutter/material.dart';
import '../service/jadwal_service.dart';
import '../models/jadwal.dart';
import 'edit_jadwal.dart'; // pastikan ini sesuai dengan file edit jadwal yang benar

// Halaman utama untuk menampilkan daftar jadwal
class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  late Future<List<Jadwal>> _futureJadwal;

  @override
  void initState() {
    super.initState();
    // Ambil data jadwal saat halaman pertama kali dibuka
    _futureJadwal = JadwalService.fetchJadwalList();
  }

  // Fungsi untuk refresh data jadwal
  Future<void> _refresh() async {
    setState(() {
      _futureJadwal = JadwalService.fetchJadwalList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  items: const [
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
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/tambahjadwal',
                    );
                    if (result == true) {
                      _refresh();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Jadwal"),
                ),
              ],
            ),
            const SizedBox(height: 16), // Spasi antar elemen
            // ListView untuk menampilkan semua jadwal
            Expanded(
              child: FutureBuilder<List<Jadwal>>(
                future: _futureJadwal,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Text(
                          'Gagal memuat data:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  final jadwalList = snapshot.data ?? [];
                  if (jadwalList.isEmpty) {
                    return const Center(child: Text('Belum ada jadwal'));
                  }
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: jadwalList.length,
                      itemBuilder: (context, index) {
                        final jadwal = jadwalList[index];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Tampilkan hari jadwal
                                      Text(
                                        (jadwal.hari.isNotEmpty ? jadwal.hari.join(', ') : '-'),
                                        style: const TextStyle(
                                          color: Color(0xFF7A3CFF),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Nama jadwal
                                      Text(
                                        jadwal.namaJadwal,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Kategori jadwal
                                      Text(
                                        "Kategori: ${jadwal.kategori}",
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      // Catatan/deskripsi jadwal
                                      Text(
                                        "Deskripsi: ${jadwal.catatan ?? ''}",
                                      ),
                                      // Waktu mulai dan selesai
                                      Text(
                                        "${jadwal.waktuMulai} - ${jadwal.waktuSelesai}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol untuk pindah ke halaman EditJadwalPage (hanya tampilan)
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: const Color(0xFF7A3CFF),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditJadwalPage(
                                          jadwalId: jadwal.id,
                                          jadwalData: jadwal.toJson(),
                                        ),
                                      ),
                                    ).then((result) {
                                      if (result == true) {
                                        _refresh();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
