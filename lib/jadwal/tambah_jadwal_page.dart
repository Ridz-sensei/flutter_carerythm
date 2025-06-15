import 'package:flutter/material.dart';
import '../service/jadwal_service.dart';
import 'dart:convert';

// Halaman Tambah Jadwal
class TambahJadwalPage extends StatefulWidget {
  const TambahJadwalPage({super.key});

  @override
  State<TambahJadwalPage> createState() => _TambahJadwalPageState();
}

class _TambahJadwalPageState extends State<TambahJadwalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  final List<String> _kategoriList = [
    'Pelajaran',
    'Olahraga',
    'Hiburan',
    'Lainnya',
  ];
  final List<String> _hariList = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  final List<String> _hariTerpilih = [];

  String? _kategoriTerpilih;
  TimeOfDay? _waktuMulai;
  TimeOfDay? _waktuSelesai;
  bool _isLoading = false;

  Future<void> _pilihWaktu(BuildContext context, bool isMulai) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isMulai) {
          _waktuMulai = picked;
        } else {
          _waktuSelesai = picked;
        }
      });
    }
  }

  Future<void> _simpanJadwal() async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState!.validate() ||
        _kategoriTerpilih == null ||
        _waktuMulai == null ||
        _waktuSelesai == null ||
        _hariTerpilih.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi!')),
      );
      return;
    }

    final jadwal = {
      'nama_jadwal': _namaController.text,
      'kategori': _kategoriTerpilih,
      'waktu_mulai': "${_waktuMulai!.hour.toString().padLeft(2, '0')}:${_waktuMulai!.minute.toString().padLeft(2, '0')}",
      'waktu_selesai': "${_waktuSelesai!.hour.toString().padLeft(2, '0')}:${_waktuSelesai!.minute.toString().padLeft(2, '0')}",
      // Kirim hari sebagai array agar validasi backend tidak error
      'hari': List<String>.from(_hariTerpilih),
      'catatan': _deskripsiController.text.isEmpty ? null : _deskripsiController.text,
    };
    print('Data dikirim ke backend: $jadwal');
    try {
      final success = await JadwalService.addJadwal(jadwal);
      setState(() {
        _isLoading = false;
      });
      if (success) {
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jadwal berhasil ditambahkan')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      String errorMsg = 'Gagal menambah jadwal: $e';
      try {
        final err = e.toString();
        final jsonStart = err.indexOf('{');
        if (jsonStart != -1) {
          final jsonStr = err.substring(jsonStart);
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map && decoded['message'] != null) {
            errorMsg = decoded['message'].toString();
          }
        }
      } catch (_) {}
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Jadwal"),
        backgroundColor: const Color(0xFF7A3CFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Jadwal',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama jadwal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _kategoriList
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                value: _kategoriTerpilih,
                onChanged: (value) {
                  setState(() {
                    _kategoriTerpilih = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih kategori' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value != null && value.length > 255 ? 'Maksimal 255 karakter' : null,
              ),
              const SizedBox(height: 16),
              const Text('Pilih Hari:'),
              Wrap(
                spacing: 8,
                children: _hariList.map((hari) {
                  return FilterChip(
                    label: Text(hari),
                    selected: _hariTerpilih.contains(hari),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _hariTerpilih.add(hari);
                        } else {
                          _hariTerpilih.remove(hari);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pilihWaktu(context, true),
                      child: Text(
                        _waktuMulai != null
                            ? 'Mulai: ${_waktuMulai!.hour.toString().padLeft(2, '0')}:${_waktuMulai!.minute.toString().padLeft(2, '0')}'
                            : 'Waktu Mulai',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pilihWaktu(context, false),
                      child: Text(
                        _waktuSelesai != null
                            ? 'Selesai: ${_waktuSelesai!.hour.toString().padLeft(2, '0')}:${_waktuSelesai!.minute.toString().padLeft(2, '0')}'
                            : 'Waktu Selesai',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _simpanJadwal();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A3CFF),
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
