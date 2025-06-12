import 'package:flutter/material.dart';
import '../service/kegiatan_service.dart';
import '../models/kegiatan.dart';

class PageKegiatan extends StatefulWidget {
  const PageKegiatan({super.key});

  @override
  State<PageKegiatan> createState() => _PageKegiatanState();
}

class _PageKegiatanState extends State<PageKegiatan> {
  late Future<List<Kegiatan>> _futureKegiatan;

  @override
  void initState() {
    super.initState();
    _futureKegiatan = ApiService.fetchKegiatan();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureKegiatan = ApiService.fetchKegiatan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kegiatan'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color.fromRGBO(138, 43, 226, 0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('+ Tambah Kegiatan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.pushNamed(context, '/tambah');
                    if (result == true) {
                      await _refresh(); //refresh setelah tambah
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Kegiatan>>(
                  future: _futureKegiatan,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      // Tampilkan pesan error detail
                      return Center(
                        child: SingleChildScrollView(
                          child: Text(
                            'Gagal memuat data:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    final kegiatanList = snapshot.data ?? [];
                    if (kegiatanList.isEmpty) {
                      return const Center(child: Text('Belum ada kegiatan'));
                    }
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        itemCount: kegiatanList.length,
                        itemBuilder: (context, index) {
                          final kegiatan = kegiatanList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Card(
                              color: Colors.white.withOpacity(0.2),
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kegiatan.kegiatan,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text('Catatan: ${kegiatan.catatan ?? "-"}'),
                                    Text('Tanggal: ${kegiatan.tanggal}'),
                                    Text('Waktu: ${kegiatan.waktuMulai} - ${kegiatan.waktuSelesai}'),
                                    Text('Tempat: ${kegiatan.tempat ?? "-"}'),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            final result = await Navigator.pushNamed(
                                              context,
                                              '/edit',
                                              arguments: kegiatan.toJson(),
                                            );
                                            if (result == true) {
                                              await _refresh();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            textStyle: const TextStyle(fontSize: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Edit'),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Konfirmasi'),
                                                  content: const Text('Apakah Anda yakin ingin menghapus kegiatan ini?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: const Text('Batal'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      child: const Text('Hapus'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (confirm == true) {
                                              final success = await ApiService.deleteKegiatan(kegiatan.id);
                                              if (success) {
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Kegiatan berhasil dihapus')),
                                                  );
                                                  _refresh();
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
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            textStyle: const TextStyle(fontSize: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
      ),
    );
  }
}