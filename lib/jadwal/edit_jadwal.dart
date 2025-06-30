import 'package:flutter/material.dart';
import '../service/jadwal_service.dart';

// Halaman Edit Jadwal
class EditJadwalPage extends StatefulWidget {
  // menerima id dan data jadwal yang akan diedit
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _catatanController;
  String? _kategoriTerpilih;
  List<String> _hariTerpilih = [];
  TimeOfDay? _waktuMulai;
  TimeOfDay? _waktuSelesai;

  // Daftar kategori yang tersedia
  final List<String> _kategoriList = [
    'Pelajaran',
    'Olahraga',
    'Hiburan',
    'Lainnya',
  ];
  // Daftar hari dalam seminggu
  final List<String> _hariList = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dan data awal dari jadwalData
    _namaController = TextEditingController(
      text: widget.jadwalData['nama_jadwal'] ?? widget.jadwalData['nama'] ?? '',
    );
    _catatanController = TextEditingController(
      text: widget.jadwalData['catatan'] ?? widget.jadwalData['deskripsi'] ?? '',
    );
    _kategoriTerpilih = widget.jadwalData['kategori'];
    final hariRaw = widget.jadwalData['hari'];
    if (hariRaw is List) {
      _hariTerpilih = List<String>.from(hariRaw);
    } else if (hariRaw is String) {
      _hariTerpilih = hariRaw.split(',').map((e) => e.trim()).toList();
    }
    _waktuMulai = _parseTime(widget.jadwalData['waktu_mulai']);
    _waktuSelesai = _parseTime(widget.jadwalData['waktu_selesai']);
  }

  // Fungsi untuk parsing waktu dari string ke TimeOfDay
  TimeOfDay? _parseTime(dynamic time) {
    if (time == null || time.toString().isEmpty) return null;
    final parts = time.toString().split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  // Fungsi untuk memilih waktu mulai/selesai
  Future<void> _pilihWaktu(BuildContext context, bool isMulai) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMulai
          ? (_waktuMulai ?? TimeOfDay.now())
          : (_waktuSelesai ?? TimeOfDay.now()),
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

  // Fungsi untuk update jadwal ke backend
  Future<void> _updateJadwal() async {
    if (!_formKey.currentState!.validate() ||
        _kategoriTerpilih == null ||
        _waktuMulai == null ||
        _waktuSelesai == null ||
        _hariTerpilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi!')),
      );
      return;
    }
    final data = {
      'nama_jadwal': _namaController.text,
      'kategori': _kategoriTerpilih,
      'waktu_mulai': "${_waktuMulai!.hour.toString().padLeft(2, '0')}:${_waktuMulai!.minute.toString().padLeft(2, '0')}",
      'waktu_selesai': "${_waktuSelesai!.hour.toString().padLeft(2, '0')}:${_waktuSelesai!.minute.toString().padLeft(2, '0')}",
      // Kirim hari sebagai array agar validasi backend tidak error
      'hari': List<String>.from(_hariTerpilih),
      'catatan': _catatanController.text,
    };
    try {
      final success = await JadwalService.updateJadwal(widget.jadwalId, data);
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal update jadwal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan koneksi: $e')),
      );
    }
  }

  // Fungsi untuk menghapus jadwal
  Future<void> _deleteJadwal() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final success = await JadwalService.deleteJadwal(widget.jadwalId);
        if (success) {
          if (mounted) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Jadwal berhasil dihapus')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus jadwal')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan koneksi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Jadwal'), backgroundColor: const Color(0xFF7A3CFF)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Input nama jadwal
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
              // Dropdown kategori
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                value: _kategoriTerpilih,
                items: _kategoriList
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _kategoriTerpilih = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih kategori' : null,
              ),
              const SizedBox(height: 16),
              // Input catatan
              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value != null && value.length > 255 ? 'Maksimal 255 karakter' : null,
              ),
              const SizedBox(height: 16),
              // Pilihan hari
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
              // Pilihan waktu mulai dan selesai
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
              // Tombol simpan perubahan
              ElevatedButton(
                onPressed: _updateJadwal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A3CFF),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Simpan Perubahan"),
              ),
              const SizedBox(height: 12),
              // Tombol hapus jadwal
              ElevatedButton.icon(
                onPressed: _deleteJadwal,
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text("Hapus Jadwal"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
