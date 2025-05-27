import 'package:flutter/material.dart';

class EditKegiatan extends StatefulWidget {
  const EditKegiatan({super.key});

  @override
  State<EditKegiatan> createState() => _EditKegiatanState();
}

class _EditKegiatanState extends State<EditKegiatan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController(text: 'Membaca');
  final TextEditingController _deskripsiController = TextEditingController(text: 'Baca buku 10 halaman');
  String _kategori = 'Membaca';
  TimeOfDay _waktu = const TimeOfDay(hour: 8, minute: 30);
  DateTime _tanggal = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kegiatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kegiatan',
                  border: OutlineInputBorder(),
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
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Olahraga', child: Text('Olahraga')),
                  DropdownMenuItem(value: 'Membaca', child: Text('Membaca')),
                ],
                onChanged: (value) {
                  setState(() {
                    _kategori = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 10),
              ListTile(
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
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Waktu'),
                subtitle: Text('${_waktu.hour}:${_waktu.minute.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final newTime = await showTimePicker(
                    context: context,
                    initialTime: _waktu,
                  );
                  if (newTime != null) {
                    setState(() {
                      _waktu = newTime;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Simpan perubahan dan kembali ke halaman sebelumnya
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Simpan'),
                    
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}