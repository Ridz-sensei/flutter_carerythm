import 'package:flutter/material.dart';
import '../service/jadwal_service.dart';

// Halaman Edit Jadwal
class EditJadwalPage extends StatefulWidget {
  final int jadwalId;
  final Map<String, dynamic> jadwalData;
  const EditJadwalPage({
    super.key,
    required this.jadwalId,
    required this.jadwalData,
  });

  @override
  State<EditJadwalPage> createState() => _EditJadwalPageState();
}

class _EditJadwalPageState extends State<EditJadwalPage> {
  final JadwalService _jadwalService = JadwalService(
    baseUrl: 'http://localhost:8000/api',
  );
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.jadwalData['nama'] ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.jadwalData['deskripsi'] ?? '',
    );
  }

  Future<void> _updateJadwal() async {
    final data = {
      'nama': _namaController.text,
      'deskripsi': _deskripsiController.text,
    };
    try {
      final response = await _jadwalService.updateJadwal(widget.jadwalId, data);
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal update jadwal')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan koneksi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Jadwal')),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          TextField(
            controller: _namaController,
            decoration: InputDecoration(labelText: 'Nama Kegiatan'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _deskripsiController,
            decoration: InputDecoration(labelText: 'Deskripsi'),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _updateJadwal,
            child: Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }
}
