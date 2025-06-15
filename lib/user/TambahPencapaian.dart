import 'package:flutter/material.dart';
import '../models/pencapaian.dart';
import '../service/pencapaian_service.dart';

class AddPencapaianPage extends StatefulWidget {
  final String token;
  const AddPencapaianPage({super.key, required this.token});

  @override
  State<AddPencapaianPage> createState() => _AddPencapaianPageState();
}

class _AddPencapaianPageState extends State<AddPencapaianPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  DateTime? waktuPencapaian;

  Future<void> pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        waktuPencapaian = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pencapaian"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text("Nama Kegiatan", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Contoh: Menyelesaikan Modul 1",
              ),
            ),
            const SizedBox(height: 20),
            const Text("Jumlah", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Contoh: 5",
              ),
            ),
            const SizedBox(height: 20),
            const Text("Target", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Contoh: 10",
              ),
            ),
            const SizedBox(height: 20),
            const Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: kategoriController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Contoh: Pelajaran",
              ),
            ),
            const SizedBox(height: 20),
            const Text("Tanggal Pencapaian", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ListTile(
              tileColor: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(
                waktuPencapaian != null
                  ? "${waktuPencapaian!.day}/${waktuPencapaian!.month}/${waktuPencapaian!.year}"
                  : "Pilih Tanggal",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => pilihTanggal(context),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Batal", style: TextStyle(color: Colors.white),),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String nama = namaController.text;
                    String target = targetController.text;
                    String kategori = kategoriController.text;
                    if (nama.isEmpty || target.isEmpty || kategori.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nama, target, dan kategori wajib diisi!')),
                      );
                      return;
                    }
                    final pencapaian = Pencapaian(
                      nama: nama,
                      jumlah: 0, // jumlah selalu 0 saat tambah baru (backend handle)
                      target: int.tryParse(target) ?? 0,
                      kategori: kategori,
                      waktuPencapaian: "", // backend handle waktu_pencapaian
                    );
                    try {
                      bool success = await PencapaianService.tambahPencapaian(pencapaian, widget.token);
                      if (success) {
                        if (mounted) {
                          Navigator.pop(context, true);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal menambah pencapaian')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menambah pencapaian: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Tambahkan", style: TextStyle(color: Colors.white),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
