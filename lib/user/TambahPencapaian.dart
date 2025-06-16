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

  @override
  void initState() {
    super.initState();
    // Debug token saat page load
    print("Token yang diterima AddPencapaianPage: ${widget.token}");
    _debugTokenOnLoad();
  }

  Future<void> _debugTokenOnLoad() async {
    await PencapaianService.debugToken();
    bool tokenValid = await PencapaianService.testToken();
    print("Apakah token valid? $tokenValid");
  }

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
        actions: [
          // Tambah tombol debug
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () async {
              await PencapaianService.debugToken();
              bool tokenValid = await PencapaianService.testToken();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Token valid: $tokenValid'),
                    backgroundColor: tokenValid ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Debug info
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   margin: const EdgeInsets.only(bottom: 20),
            //   decoration: BoxDecoration(
            //     color: Colors.grey[200],
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text("Debug Info:", style: TextStyle(fontWeight: FontWeight.bold)),
            //       const SizedBox(height: 5),
            //       Text("Token: ${widget.token}"),
            //       Text("Token length: ${widget.token.length}"),
            //       Text("Token starts with: ${widget.token.substring(0, widget.token.length > 10 ? 10 : widget.token.length)}..."),
            //     ],
            //   ),
            // ),
            
            const Text("Nama Pencapaian", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Contoh: Menyelesaikan Modul 1",
              ),
            ),
            const SizedBox(height: 20),
            
            const Text("Waktu Pencapaian", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => pilihTanggal(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      waktuPencapaian != null
                          ? "${waktuPencapaian!.day}/${waktuPencapaian!.month}/${waktuPencapaian!.year}"
                          : "Pilih tanggal",
                      style: TextStyle(
                        color: waktuPencapaian != null ? Colors.black : Colors.grey,
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pilih Kategori',
              ),
              value: kategoriController.text.isEmpty ? null : kategoriController.text,
              items: ['pelajaran', 'istirahat', 'olahraga', 'hiburan']
                  .map((kategori) => DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  kategoriController.text = value ?? '';
                });
              },
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
                  child: const Text("Batal", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String nama = namaController.text.trim();
                    String target = targetController.text.trim();
                    String kategori = kategoriController.text.trim();
                    
                    // Validasi input yang lebih ketat
                    if (nama.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nama pencapaian wajib diisi!')),
                      );
                      return;
                    }
                    
                    if (target.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Target wajib diisi!')),
                      );
                      return;
                    }
                    
                    if (kategori.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kategori wajib dipilih!')),
                      );
                      return;
                    }
                    
                    if (waktuPencapaian == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Waktu pencapaian wajib dipilih!')),
                      );
                      return;
                    }
                    
                    int targetInt = int.tryParse(target) ?? 0;
                    if (targetInt <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Target harus berupa angka positif!')),
                      );
                      return;
                    }

                    // Test token sebelum mengirim data
                    print("=== DEBUG TOKEN SEBELUM KIRIM ===");
                    await PencapaianService.debugToken();
                    bool tokenValid = await PencapaianService.testToken();
                    print("Token valid sebelum kirim: $tokenValid");

                    final pencapaian = Pencapaian(
                      nama: nama,
                      jumlah: 0,
                      target: targetInt,
                      kategori: kategori,
                      waktuPencapaian: waktuPencapaian!.toIso8601String().split('T')[0],
                    );
                    
                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      
                      // Kirim dengan token null agar service menggunakan SharedPreferences
                      bool success = await PencapaianService.tambahPencapaian(pencapaian, null);
                      
                      if (mounted) Navigator.pop(context);
                      
                      if (success) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pencapaian berhasil ditambahkan!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context, true);
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gagal menambah pencapaian. Periksa token dan coba lagi.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) Navigator.pop(context);
                      
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Tambahkan", style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}