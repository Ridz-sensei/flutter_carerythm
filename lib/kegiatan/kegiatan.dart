import '../editKegiatan.dart';
import 'package:flutter/material.dart';
import 'tambahKegiatan.dart';

class PageKegiatan extends StatelessWidget {
  const PageKegiatan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kegiatan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TambahKegiatan()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Kegiatan'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        // Image.asset(
                        // 'assets/oRaurus.jpg',
                        // height: 100,
                        // width: 100,
                        // alignment: Alignment.topLeft,
                        // ),
                        ListTile(
                          title: const Text('Membaca'),
                          subtitle: const Text(
                            'Baca buku 10 halaman - Rabu, Kamis, Jumat - 08.30',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Aksi pindah halaman di sini
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditKegiatan(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
