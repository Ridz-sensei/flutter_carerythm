import 'package:flutter/material.dart';
import '../models/pencapaian.dart';
import '../service/pencapaian_service.dart';
import '../user/TambahPencapaian.dart';

class HalamanPencapaian extends StatefulWidget {
  final String token; // Tambahkan token jika perlu autentikasi tambah
  const HalamanPencapaian({super.key, required this.token});

  @override
  State<HalamanPencapaian> createState() => _HalamanPencapaianState();
}

class _HalamanPencapaianState extends State<HalamanPencapaian> {
  List<Pencapaian> _pencapaians = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPencapaian();
  }

  Future<void> _fetchPencapaian() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await PencapaianService.fetchPencapaian();
      setState(() {
        _pencapaians = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat pencapaian: $e';
        _isLoading = false;
      });
    }
  }

  void _tambahPencapaian() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPencapaianPage(token: widget.token),
      ),
    );
    if (result == true) {
      _fetchPencapaian();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Pencapaian'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPencapaian,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ...bisa tambahkan summary/target progress di sini jika ingin...
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _pencapaians.isEmpty
                          ? const Center(child: Text('Belum ada pencapaian.'))
                          : ListView.builder(
                              itemCount: _pencapaians.length,
                              itemBuilder: (context, index) {
                                final item = _pencapaians[index];
                                return Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.emoji_events, color: Colors.amber),
                                    title: Text(item.nama),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Jumlah: ${item.jumlah} / ${item.target}'),
                                        if (item.kategori != null && item.kategori!.isNotEmpty)
                                          Text('Kategori: ${item.kategori}'),
                                        Text('Tanggal: ${item.waktuPencapaian}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _tambahPencapaian,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Tambah",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                // Tombol hapus bisa ditambahkan sesuai kebutuhan
              ],
            ),
          ],
        ),
      ),
    );
  }
}