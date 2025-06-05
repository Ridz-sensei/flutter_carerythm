import 'package:flutter/material.dart';

class TambahTemanPage extends StatelessWidget {
  const TambahTemanPage({super.key});

  final List<Map<String, String>> calonTeman = const [
    {"nama": "Akbar", "status": "Terakhir aktif satu jam yang lalu"},
    {"nama": "Daniel", "status": "Terakhir aktif dua hari yang lalu"},
    {"nama": "Laura", "status": "Terakhir aktif satu jam yang lalu"},
    {"nama": "Diana", "status": "Terakhir aktif lima menit yang lalu"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      body: SafeArea(
        child: Column(
          children: [
            // Kotak pencarian
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Cari nama atau email",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "Orang yang mungkin kamu kenal",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Daftar teman potensial
            Expanded(
              child: ListView.builder(
                itemCount: calonTeman.length,
                itemBuilder: (context, index) {
                  final teman = calonTeman[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        teman["nama"]!,
                        style: const TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                      subtitle: Text(
                        teman["status"]!,
                        style: const TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.person_add, color: Colors.deepPurple),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${teman["nama"]} ditambahkan ke teman.')),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC08DE8), // Nuansa ungu sebagai aksen
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Kembali"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
