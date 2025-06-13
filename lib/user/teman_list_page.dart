import 'package:flutter/material.dart';
import 'profil_teman_page.dart';

class TemanListPage extends StatelessWidget {
  const TemanListPage({super.key});

  final List<Map<String, dynamic>> daftarTeman = const [
    {
      "nama": "Akbar",
      "email": "akbar@email.com",
      "fotoUrl": "https://i.pravatar.cc/150?img=1",
      "deskripsi": "Pengembang Flutter dan penggemar UI.",
      "bergabung": "Jan 2022",
      "totalMasuk": 120,
      "terakhirMasuk": "10 Mei 2025",
    },
    {
      "nama": "Daniel",
      "email": "daniel@email.com",
      "fotoUrl": "https://i.pravatar.cc/150?img=2",
      "deskripsi": "Backend developer dan penyuka kopi.",
      "bergabung": "Mar 2021",
      "totalMasuk": 98,
      "terakhirMasuk": "9 Mei 2025",
    },
    {
      "nama": "Laura",
      "email": "laura@email.com",
      "fotoUrl": "https://i.pravatar.cc/150?img=3",
      "deskripsi": "UI/UX designer dan pecinta kucing.",
      "bergabung": "Feb 2023",
      "totalMasuk": 150,
      "terakhirMasuk": "11 Mei 2025",
    },
    {
      "nama": "Diana",
      "email": "diana@email.com",
      "fotoUrl": "https://i.pravatar.cc/150?img=4",
      "deskripsi": "Project manager dan traveler.",
      "bergabung": "Apr 2022",
      "totalMasuk": 200,
      "terakhirMasuk": "8 Mei 2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC08DE8),
        title: const Text(
          "Daftar Teman",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: daftarTeman.length,
        itemBuilder: (context, index) {
          final teman = daftarTeman[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(teman["fotoUrl"]),
              ),
              title: Text(
                teman["nama"],
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              subtitle: Text(
                teman["email"],
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProfilTemanPage(
                          nama: teman["nama"],
                          email: teman["email"],
                          fotoUrl: teman["fotoUrl"],
                          deskripsi: teman["deskripsi"],
                          bergabung: teman["bergabung"],
                          totalMasuk: teman["totalMasuk"],
                          terakhirMasuk: teman["terakhirMasuk"],
                        ),
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.message, color: Colors.deepPurple),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Pesan ke ${teman["nama"]} belum didukung.',
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
