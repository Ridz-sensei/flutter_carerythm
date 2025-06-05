import 'package:flutter/material.dart';

// Halaman untuk menampilkan form edit jadwal (hanya tampilan, tanpa logika)
class EditJadwalPage extends StatelessWidget {
  const EditJadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul dan warna
      appBar: AppBar(
        title: const Text("Edit Jadwal"),
        backgroundColor: const Color(0xFF7A3CFF),
      ),
      // Isi halaman
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            // Input untuk nama kegiatan
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nama Kegiatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Input untuk kategori kegiatan
            const TextField(
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Input untuk deskripsi kegiatan
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown untuk memilih hari
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Hari',
                border: OutlineInputBorder(),
              ),
              items: const [
                'Senin',
                'Selasa',
                'Rabu',
                'Kamis',
                'Jumat',
                'Sabtu',
                'Minggu',
              ].map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
              onChanged: (newValue) {},
            ),
            const SizedBox(height: 16),

            // Baris untuk memilih waktu mulai dan selesai
            Row(
              children: [
                // Tombol pilih waktu mulai
                const Expanded(
                  child: OutlinedButton(
                    onPressed: null,
                    child: Text("Waktu Mulai"),
                  ),
                ),
                const SizedBox(width: 12),
                // Tombol pilih waktu selesai
                const Expanded(
                  child: OutlinedButton(
                    onPressed: null,
                    child: Text("Waktu Selesai"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tombol untuk menyimpan perubahan jadwal
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A3CFF),
                foregroundColor: Colors.white,
              ),
              child: const Text("Simpan Perubahan"),
            ),
            const SizedBox(height: 16),

            // Tombol untuk menghapus jadwal
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Hapus Jadwal"),
            ),
          ],
        ),
      ),
    );
  }
}
