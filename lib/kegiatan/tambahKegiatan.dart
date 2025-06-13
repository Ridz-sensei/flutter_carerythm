import 'package:flutter/material.dart';
import '../service/kegiatan_service.dart';

class TambahKegiatan extends StatefulWidget {
  const TambahKegiatan({super.key});

  @override
  State<TambahKegiatan> createState() => _TambahKegiatanState();
}

class _TambahKegiatanState extends State<TambahKegiatan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tempatController = TextEditingController();
  TimeOfDay _waktuMulai = const TimeOfDay(hour: 8, minute: 30);
  TimeOfDay _waktuSelesai = const TimeOfDay(hour: 9, minute: 30);
  DateTime _tanggal = DateTime.now();
  bool _isLoading = false;

  Future<void> _simpanKegiatan() async {
    setState(() {
      _isLoading = true;
    });
    final kegiatan = {
      'id': 0,
      'kegiatan': _namaController.text,
      'catatan': _deskripsiController.text,
      'tanggal': "${_tanggal.year.toString().padLeft(4, '0')}-${_tanggal.month.toString().padLeft(2, '0')}-${_tanggal.day.toString().padLeft(2, '0')}",
      'waktu_mulai': "${_waktuMulai.hour.toString().padLeft(2, '0')}:${_waktuMulai.minute.toString().padLeft(2, '0')}",
      'waktu_selesai': "${_waktuSelesai.hour.toString().padLeft(2, '0')}:${_waktuSelesai.minute.toString().padLeft(2, '0')}",
      'tempat': _tempatController.text.isEmpty ? null : _tempatController.text,
      
    };
    print('Data dikirim ke backend: $kegiatan');
    try {
      final success = await ApiService.tambahKegiatan(kegiatan);
      setState(() {
        _isLoading = false;
      });
      if (success) {
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kegiatan berhasil ditambahkan')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambah kegiatan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                        'Tambah Kegiatan',
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
                        controller: _deskripsiController,
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
                                      _simpanKegiatan();
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
                                : const Text('Simpan'),
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