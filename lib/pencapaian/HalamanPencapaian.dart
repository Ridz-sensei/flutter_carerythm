import 'package:flutter/material.dart';
import '../models/pencapaian.dart';
import '../service/pencapaian_service.dart';
import '../user/TambahPencapaian.dart';

class HalamanPencapaian extends StatefulWidget {
  final String token; // Tambahkan token jika perlu autentikasi tambah
  const HalamanPencapaian({super.key, required this.token});

  @override
  State<HalamanPencapaian> createState() => _HalamanPencapaianState();
}

class _HalamanPencapaianState extends State<HalamanPencapaian> {
  List<Pencapaian> _pencapaians = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPencapaian();
  }

  Future<void> _fetchPencapaian() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await PencapaianService.fetchPencapaian();
      setState(() {
        _pencapaians = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat pencapaian: $e';
        _isLoading = false;
      });
    }
  }

  void _tambahPencapaian() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPencapaianPage(token: widget.token),
      ),
    );
    if (result == true) {
      _fetchPencapaian();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Pencapaian'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPencapaian,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Target Kamu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Olahraga'),
                      Text('6/10'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 12,
                    backgroundColor: Colors.deepPurple[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Membaca'),
                      Text('4/20'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.2,
                    minHeight: 12,
                    backgroundColor: Colors.deepPurple[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: const Icon(Icons.emoji_events, color: Colors.amber),
                      title: const Text('Belajar 7 Hari Berturut-turut'),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                  ),

                  Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: const Icon(Icons.task_alt, color: Colors.green),
                      title: const Text('Mengerjakan semua tugas minggu ini'),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                  ),

                  Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: const Icon(Icons.alarm, color: Colors.orange),
                      title: const Text('Bangun pagi 5x'),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context)=>AddPencapaianPage())
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white,),
                  label: const Text("Tambah", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.delete, color: Colors.white,),
                  label: const Text("Hapus", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
