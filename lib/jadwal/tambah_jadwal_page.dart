import 'package:flutter/material.dart';

// Halaman Tambah Jadwal
class TambahJadwalPage extends StatefulWidget {
  const TambahJadwalPage({super.key});

  @override
  State<TambahJadwalPage> createState() => _TambahJadwalPageState();
}

class _TambahJadwalPageState extends State<TambahJadwalPage> {
  // Controller untuk input nama kegiatan
  final TextEditingController _namaController = TextEditingController();
  // Controller untuk input deskripsi kegiatan
  final TextEditingController _deskripsiController = TextEditingController();

  // Daftar hari yang bisa dipilih
  final List<String> _hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  // Hari-hari yang dipilih user
  final List<String> _hariTerpilih = [];

  // Kategori kegiatan yang dipilih user
  String? _kategoriTerpilih;

  // Waktu mulai dan selesai yang dipilih
  TimeOfDay? _waktuMulai;
  TimeOfDay? _waktuSelesai;

  // Fungsi untuk menampilkan pemilih waktu (TimePicker)
  Future<void> _pilihWaktu(BuildContext context, bool isMulai) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isMulai) {
          _waktuMulai = picked;
        } else {
          _waktuSelesai = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Jadwal"),
        backgroundColor: const Color(0xFF7A3CFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            // Input nama kegiatan
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Kegiatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Input deskripsi kegiatan
            TextField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Dropdown untuk memilih kategori kegiatan
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Olahraga', child: Text('Olahraga')),
                DropdownMenuItem(value: 'Membaca', child: Text('Membaca')),
              ],
              value: _kategoriTerpilih,
              onChanged: (value) {
                setState(() {
                  _kategoriTerpilih = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Judul untuk bagian hari
            const Text('Pilih Hari:'),
            // Chip pilihan hari
            Wrap(
              spacing: 8,
              children:
                  _hari.map((hari) {
                    return FilterChip(
                      label: Text(hari),
                      selected: _hariTerpilih.contains(hari),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _hariTerpilih.add(hari);
                          } else {
                            _hariTerpilih.remove(hari);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            // Pilihan waktu mulai dan selesai dalam satu baris
            Row(
              children: [
                // Tombol untuk pilih waktu mulai
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pilihWaktu(context, true),
                    child: Text(
                      _waktuMulai != null
                          ? 'Mulai: ${_waktuMulai!.format(context)}'
                          : 'Waktu Mulai',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Tombol untuk pilih waktu selesai
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pilihWaktu(context, false),
                    child: Text(
                      _waktuSelesai != null
                          ? 'Selesai: ${_waktuSelesai!.format(context)}'
                          : 'Waktu Selesai',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Tombol simpan
            ElevatedButton(
              onPressed: () {
                // Di sini kamu bisa tambahkan validasi dan simpan data
                // Contoh validasi bisa: pastikan semua field terisi

                // Setelah simpan, kembali ke halaman sebelumnya
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A3CFF),
                foregroundColor: Colors.white,
              ),
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
