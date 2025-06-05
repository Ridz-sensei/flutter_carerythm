import 'package:flutter/material.dart';

class ProfilTemanPage extends StatelessWidget {
  final String nama;
  final String email;
  final String fotoUrl;
  final String deskripsi;
  final String bergabung;
  final int totalMasuk;
  final String terakhirMasuk;

  const ProfilTemanPage({
    super.key,
    required this.nama,
    required this.email,
    required this.fotoUrl,
    required this.deskripsi,
    required this.bergabung,
    required this.totalMasuk,
    required this.terakhirMasuk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDCF9),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC08DE8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text("Kembali"),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFD3AAFD),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 4),
                    blurRadius: 6,
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(fotoUrl),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 12),
                  Text(nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(email, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: const Color(0xFFF2E7FE),
                    child: const Text("   Profil", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.purple)),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tentang", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(deskripsi),
                        const SizedBox(height: 8),
                        Text("Bergabung: $bergabung", style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text("Total Masuk: $totalMasuk", style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text("Terakhir Masuk: $terakhirMasuk", style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
