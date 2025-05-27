import 'package:flutter/material.dart';

class AddPencapaianPage extends StatefulWidget {
  const AddPencapaianPage({super.key});

  @override
  State<AddPencapaianPage> createState() => _AddPencapaianPageState();
}

class _AddPencapaianPageState extends State<AddPencapaianPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  DateTime? tanggalMulai;
  DateTime? tanggalSelesai;

  Future<void> pilihTanggal(BuildContext context, bool mulai) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (mulai) {
          tanggalMulai = picked;
        } else {
          tanggalSelesai = picked;
        }
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

            const Text("Tanggal Mulai", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ListTile(
              tileColor: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(
                tanggalMulai != null
                  ? "${tanggalMulai!.day}/${tanggalMulai!.month}/${tanggalMulai!.year}"
                  : "Pilih Tanggal Mulai",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => pilihTanggal(context, true),
            ),

            const SizedBox(height: 15),

            const Text("Tanggal Selesai", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ListTile(
              tileColor: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(
                tanggalSelesai != null
                  ? "${tanggalSelesai!.day}/${tanggalSelesai!.month}/${tanggalSelesai!.year}"
                  : "Pilih Tanggal Selesai",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => pilihTanggal(context, false),
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
                  onPressed: () {
                    String nama = namaController.text;
                    String jumlah = jumlahController.text;
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
