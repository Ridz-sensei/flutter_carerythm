import 'package:flutter/material.dart';
import '../models/kegiatan.dart';
import '../service/kegiatan_service.dart';

class EditKegiatan extends StatefulWidget {
  const EditKegiatan({super.key});

  @override
  State<EditKegiatan> createState() => _EditKegiatanState();
}

class _EditKegiatanState extends State<EditKegiatan> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _catatanController;
  late TextEditingController _tempatController;
  late DateTime _tanggal;
  late TimeOfDay _waktuMulai;
  late TimeOfDay _waktuSelesai;
  bool _isLoading = false;
  late Kegiatan kegiatan;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      kegiatan = Kegiatan.fromJson(args);
    } else {
      throw Exception('Argumen tidak valid untuk EditKegiatan');
    }
    _namaController = TextEditingController(text: kegiatan.kegiatan);
    _catatanController = TextEditingController(text: kegiatan.catatan ?? '');
    _tempatController = TextEditingController(text: kegiatan.tempat ?? '');
    _tanggal = DateTime.parse(kegiatan.tanggal);
    _waktuMulai = _parseTime(kegiatan.waktuMulai);
    _waktuSelesai = _parseTime(kegiatan.waktuSelesai);
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<void> _updateKegiatan() async {
    setState(() {
      _isLoading = true;
    });
    final updated = Kegiatan(
      id: kegiatan.id,
      kegiatan: _namaController.text,
      catatan: _catatanController.text,
      tanggal: "${_tanggal.year.toString().padLeft(4, '0')}-${_tanggal.month.toString().padLeft(2, '0')}-${_tanggal.day.toString().padLeft(2, '0')}",
      waktuMulai: "${_waktuMulai.hour.toString().padLeft(2, '0')}:${_waktuMulai.minute.toString().padLeft(2, '0')}",
      waktuSelesai: "${_waktuSelesai.hour.toString().padLeft(2, '0')}:${_waktuSelesai.minute.toString().padLeft(2, '0')}",
      tempat: _tempatController.text.isEmpty ? null : _tempatController.text,
    );
    try {
      final success = await ApiService.updateKegiatan(updated.toJson()..['id'] = updated.id);
      setState(() {
        _isLoading = false;
      });
      if (success) {
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kegiatan berhasil diupdate')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update kegiatan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hilangkan AppBar agar lebih mirip desain tambah kegiatan
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color.fromRGBO(138, 43, 226, 0.5), // ungu transparan
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white.withOpacity(0.2),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edit Kegiatan',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Kegiatan',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama kegiatan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _catatanController,
                        decoration: const InputDecoration(
                          labelText: 'Catatan',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tempatController,
                        decoration: const InputDecoration(
                          labelText: 'Tempat',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Tanggal'),
                              subtitle: Text('${_tanggal.day}/${_tanggal.month}/${_tanggal.year}'),
                              trailing: const Icon(Icons.calendar_today),
                              onTap: () async {
                                final newDate = await showDatePicker(
                                  context: context,
                                  initialDate: _tanggal,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (newDate != null) {
                                  setState(() {
                                    _tanggal = newDate;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Waktu Mulai'),
                              subtitle: Text('${_waktuMulai.hour.toString().padLeft(2, '0')}:${_waktuMulai.minute.toString().padLeft(2, '0')}'),
                              trailing: const Icon(Icons.access_time),
                              onTap: () async {
                                final newTime = await showTimePicker(
                                  context: context,
                                  initialTime: _waktuMulai,
                                );
                                if (newTime != null) {
                                  setState(() {
                                    _waktuMulai = newTime;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Waktu Selesai'),
                              subtitle: Text('${_waktuSelesai.hour.toString().padLeft(2, '0')}:${_waktuSelesai.minute.toString().padLeft(2, '0')}'),
                              trailing: const Icon(Icons.access_time),
                              onTap: () async {
                                final newTime = await showTimePicker(
                                  context: context,
                                  initialTime: _waktuSelesai,
                                );
                                if (newTime != null) {
                                  setState(() {
                                    _waktuSelesai = newTime;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.deepPurple,
                            ),
                            child: const Text('Batal'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      _updateKegiatan();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Update'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
