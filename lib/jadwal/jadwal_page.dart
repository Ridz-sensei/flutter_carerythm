import 'package:flutter/material.dart';
import 'dart:convert';
import '../service/jadwal_service.dart';
import 'edit_jadwal_page.dart';
import 'tambah_jadwal_page.dart';

// Halaman utama untuk menampilkan daftar jadwal
class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final JadwalService _jadwalService = JadwalService(
    baseUrl: 'http://localhost:8000/api',
  );
  List<dynamic> _jadwalList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchJadwal();
  }

  Future<void> fetchJadwal() async {
    try {
      final response = await _jadwalService.getJadwalList();
      if (response.statusCode == 200) {
        setState(() {
          _jadwalList = List.from(jsonDecode(response.body));
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
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
              child:
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _jadwalList.length,
                        itemBuilder: (context, index) {
                          final jadwal = _jadwalList[index];
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
                                        Text(
                                          jadwal['hari'] ?? '',
                                          style: const TextStyle(
                                            color: Color(0xFF7A3CFF),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          jadwal['nama'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Kategori: ${jadwal['kategori'] ?? ''}",
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          "Deskripsi: ${jadwal['deskripsi'] ?? ''}",
                                        ),
                                        Text(
                                          "${jadwal['waktuMulai'] ?? ''} - ${jadwal['waktuSelesai'] ?? ''}",
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
                                      // Navigasi ke halaman EditJadwalPage (versi tampilan saja)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => const EditJadwalPage(),
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
