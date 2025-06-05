import 'package:flutter/material.dart';
import 'TambahPencapaian.dart';

class Pencapaian extends StatelessWidget {
  const Pencapaian({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Pencapaian'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Target Kamu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Olahraga'),
                      Text('6/10'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 12,
                    backgroundColor: Color(0xFFD1C4E9),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Membaca'),
                      Text('4/20'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.2,
                    minHeight: 12,
                    backgroundColor: Color(0xFFD1C4E9),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Daftar pencapaian
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const ListTile(
                leading: Icon(Icons.emoji_events, color: Colors.amber),
                title: Text('Belajar 7 Hari Berturut-turut'),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const ListTile(
                leading: Icon(Icons.task_alt, color: Colors.green),
                title: Text('Mengerjakan semua tugas minggu ini'),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const ListTile(
                leading: Icon(Icons.alarm, color: Colors.orange),
                title: Text('Bangun pagi 5x'),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),

            const SizedBox(height: 20),

            // Tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPencapaianPage()),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Tambah", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Fungsi hapus nanti diisi
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text("Hapus", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
