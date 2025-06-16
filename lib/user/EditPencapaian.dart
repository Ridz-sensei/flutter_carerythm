import 'package:flutter/material.dart';
import '../models/pencapaian.dart';
import '../service/pencapaian_service.dart';

class EditPencapaianPage extends StatefulWidget {
  final Pencapaian pencapaian;
  final String token;

  const EditPencapaianPage({
    super.key,
    required this.pencapaian,
    required this.token,
  });

  @override
  State<EditPencapaianPage> createState() => _EditPencapaianPageState();
}

class _EditPencapaianPageState extends State<EditPencapaianPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _targetController;
  late TextEditingController _jumlahController;
  late TextEditingController _kategoriController;
  late TextEditingController _waktuController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.pencapaian.nama);
    _targetController = TextEditingController(text: widget.pencapaian.target.toString());
    _jumlahController = TextEditingController(text: widget.pencapaian.jumlah.toString());
    _kategoriController = TextEditingController(text: widget.pencapaian.kategori ?? '');
    _waktuController = TextEditingController(text: widget.pencapaian.waktuPencapaian);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _targetController.dispose();
    _jumlahController.dispose();
    _kategoriController.dispose();
    _waktuController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(widget.pencapaian.waktuPencapaian) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null) {
      setState(() {
        _waktuController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _updatePencapaian() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedPencapaian = Pencapaian(
        id: widget.pencapaian.id,
        nama: _namaController.text,
        target: int.parse(_targetController.text),
        jumlah: int.parse(_jumlahController.text),
        kategori: _kategoriController.text.isEmpty ? null : _kategoriController.text,
        waktuPencapaian: _waktuController.text,
        userId: widget.pencapaian.userId,
      );

      final success = await PencapaianService.updatePencapaian(updatedPencapaian, widget.token);
      
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pencapaian berhasil diperbarui!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal memperbarui pencapaian'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePencapaian() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus pencapaian "${widget.pencapaian.nama}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await PencapaianService.deletePencapaian(widget.pencapaian.id!, widget.token);
        
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pencapaian berhasil dihapus!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal menghapus pencapaian'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Edit Pencapaian'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _deletePencapaian,
            tooltip: 'Hapus Pencapaian',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _namaController,
                                decoration: const InputDecoration(
                                  labelText: 'Nama Pencapaian',
                                  prefixIcon: Icon(Icons.emoji_events, color: Colors.deepPurple),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama pencapaian tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _targetController,
                                      decoration: const InputDecoration(
                                        labelText: 'Target',
                                        prefixIcon: Icon(Icons.flag, color: Colors.deepPurple),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Target tidak boleh kosong';
                                        }
                                        final target = int.tryParse(value);
                                        if (target == null || target <= 0) {
                                          return 'Target harus berupa angka positif';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _jumlahController,
                                      decoration: const InputDecoration(
                                        labelText: 'Jumlah Saat Ini',
                                        prefixIcon: Icon(Icons.trending_up, color: Colors.deepPurple),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Jumlah tidak boleh kosong';
                                        }
                                        final jumlah = int.tryParse(value);
                                        if (jumlah == null || jumlah < 0) {
                                          return 'Jumlah harus berupa angka positif atau nol';
                                        }
                                        final target = int.tryParse(_targetController.text);
                                        if (target != null && jumlah > target) {
                                          return 'Jumlah tidak boleh melebihi target';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _kategoriController,
                                decoration: const InputDecoration(
                                  labelText: 'Kategori (Opsional)',
                                  prefixIcon: Icon(Icons.category, color: Colors.deepPurple),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _waktuController,
                                decoration: InputDecoration(
                                  labelText: 'Tanggal Pencapaian',
                                  prefixIcon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.edit_calendar),
                                    onPressed: _selectDate,
                                  ),
                                ),
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tanggal pencapaian tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updatePencapaian,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Perbarui',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
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