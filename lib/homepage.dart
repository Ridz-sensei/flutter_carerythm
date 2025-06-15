import 'package:flutter/material.dart';
import 'jadwal/jadwal_page.dart';
import 'user/profil_page.dart';
import 'user/teman_list_page.dart';
import 'pencapaian/HalamanPencapaian.dart';
import 'kegiatan/Kegiatan.dart';
import 'kegiatan/tambahKegiatan.dart';
import 'service/api_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/jadwal_service.dart';
import '../models/jadwal.dart';
import '../service/kegiatan_service.dart';
import '../models/kegiatan.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  int count = 0;
  int count1 = 0;
  late Future<List<Jadwal>> _futureJadwal;
  late Future<List<Kegiatan>> _futureKegiatan;

  @override
  void initState() {
    super.initState();
    fetchUsername();
    _futureJadwal = JadwalService.fetchJadwalList();
    _futureKegiatan = KegiatanService.fetchKegiatan();
  }

  Future<void> fetchUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username') ?? '';
    setState(() {
      username = name.isNotEmpty ? name : 'User';
    });
  }

  Future<void> _refreshJadwal() async {
    setState(() {
      _futureJadwal = JadwalService.fetchJadwalList();
    });
  }

  Future<void> _refreshKegiatan() async {
    setState(() {
      _futureKegiatan = KegiatanService.fetchKegiatan();
    });
  }

  void tambah() {
    setState(() {
      count++;
    });
  }

  void tambah1() {
    setState(() {
      count1++;
    });
  }

  void dropuptambah(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SizedBox(
          height: 175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TambahKegiatan()),
                  );
                },
                child: const Text("Tambah Kegiatan"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Tambah Jadwal"),
              ),
            ],
          ),
        );
      },
    );
  }

  void dropupmenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Profil"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TemanListPage()),
                  );
                },
                child: const Text("Teman"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    // Ganti dengan token user yang valid jika sudah ada autentikasi
                    MaterialPageRoute(builder: (context) => HalamanPencapaian(token: 'DUMMY_TOKEN')),
                  );
                },
                child: const Text("Pencapaian"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageKegiatan()),
                  );
                },
                child: const Text("Kegiatan"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double paddingdaftar = 5;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // kartu profil
            Container(
              height: 140,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilPage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage('assets/images/profil.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            widget.email,
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, color: Colors.white),
                ],
              ),
            ),
            // Expanded agar seluruh konten bisa discroll
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ubah label menjadi "Jadwal Anda"
                    Container(
                      padding: const EdgeInsets.only(left: 30, bottom: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Jadwal Anda:',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Jadwal>>(
                      future: _futureJadwal,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Text(
                                'Gagal memuat jadwal:\n${snapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        final jadwalList = snapshot.data ?? [];
                        if (jadwalList.isEmpty) {
                          return const Center(child: Text('Belum ada jadwal'));
                        }
                        return Column(
                          children: jadwalList.map((jadwal) {
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(jadwal.namaJadwal, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Hari: ${jadwal.hari.join(', ')}"),
                                    Text("Jam: ${jadwal.waktuMulai} - ${jadwal.waktuSelesai}"),
                                    if (jadwal.catatan != null && jadwal.catatan!.isNotEmpty)
                                      Text("Catatan: ${jadwal.catatan}"),
                                  ],
                                ),
                                trailing: Icon(Icons.event_note, color: Colors.deepPurple),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Kegiatan Hari Ini
                    Container(
                      padding: const EdgeInsets.only(left: 30, bottom: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Kegiatan Hari Ini:',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Kegiatan>>(
                      future: _futureKegiatan,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Text(
                                'Gagal memuat kegiatan:\n${snapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        final kegiatanList = snapshot.data ?? [];
                        if (kegiatanList.isEmpty) {
                          return const Center(child: Text('Tidak ada kegiatan hari ini'));
                        }
                        return Column(
                          children: kegiatanList.map((kegiatan) {
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                              child: ListTile(
                                leading: Icon(Icons.event, color: Colors.deepPurple[400]),
                                title: Text(kegiatan.kegiatan),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${kegiatan.waktuMulai} - ${kegiatan.waktuSelesai}'),
                                    if (kegiatan.tanggal.isNotEmpty)
                                      Text('Tanggal: ${kegiatan.tanggal}'),
                                    if (kegiatan.tempat != null && kegiatan.tempat!.isNotEmpty)
                                      Text('Tempat: ${kegiatan.tempat}'),
                                    if (kegiatan.catatan != null && kegiatan.catatan!.isNotEmpty)
                                      Text('Catatan: ${kegiatan.catatan}'),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Konfirmasi'),
                                        content: const Text('Tandai kegiatan ini selesai? Kegiatan akan dihapus dari database.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Selesai', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      final success = await KegiatanService.deleteKegiatan(kegiatan.id);
                                      if (success) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Kegiatan Anda telah ditandai selesai')),
                                          );
                                          _refreshKegiatan();
                                        }
                                      } else {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Gagal menghapus kegiatan')),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple[100],
                                    foregroundColor: Colors.deepPurple[400],
                                  ),
                                  child: Text('selesai', style: TextStyle(color: Colors.deepPurple[400])),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Pencapaianmu
                    Container(
                      padding: const EdgeInsets.only(left: 30, bottom: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Pencapaianmu:', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: tambah,
                            child: Container(
                              height: 125,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.fitness_center,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('$count', style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: tambah1,
                            child: Container(
                              height: 125,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.book, size: 40, color: Colors.amber),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('$count1', style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Navbar bawah
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.deepPurple,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JadwalPage()),
                  );
                },
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  dropupmenu(context);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(0, 5),
        child: FloatingActionButton(
          onPressed: () {
            dropuptambah(context);
          },
          backgroundColor: Colors.white,
          hoverColor: Colors.white70,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.deepPurple),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
