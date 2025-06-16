import 'package:flutter/material.dart';
import '../models/pencapaian.dart';
import '../service/pencapaian_service.dart';
import '../user/TambahPencapaian.dart';
import '../user/EditPencapaian.dart';

class HalamanPencapaian extends StatefulWidget {
  final String token;
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

  void _editPencapaian(Pencapaian pencapaian) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPencapaianPage(
          pencapaian: pencapaian,
          token: widget.token,
        ),
      ),
    );
    if (result == true) {
      _fetchPencapaian();
    }
  }

  double _calculateProgress(Pencapaian pencapaian) {
    if (pencapaian.target == 0) return 0.0;
    return (pencapaian.jumlah / pencapaian.target).clamp(0.0, 1.0);
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) return Colors.green;
    if (progress >= 0.7) return Colors.orange;
    return Colors.red;
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
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchPencapaian,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      : _pencapaians.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.emoji_events_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Belum ada pencapaian.',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tambahkan pencapaian pertama Anda!',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _pencapaians.length,
                              itemBuilder: (context, index) {
                                final item = _pencapaians[index];
                                final progress = _calculateProgress(item);
                                final progressColor = _getProgressColor(progress);
                                
                                return Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                    onTap: () => _editPencapaian(item),
                                    borderRadius: BorderRadius.circular(15),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                progress >= 1.0 
                                                    ? Icons.emoji_events 
                                                    : Icons.emoji_events_outlined,
                                                color: progress >= 1.0 
                                                    ? Colors.amber 
                                                    : Colors.grey,
                                                size: 28,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.nama,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    if (item.kategori != null && item.kategori!.isNotEmpty)
                                                      Text(
                                                        item.kategori!,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              if (progress >= 1.0)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: const Text(
                                                    'SELESAI',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${item.jumlah} / ${item.target}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: progressColor,
                                                ),
                                              ),
                                              Text(
                                                '${(progress * 100).toStringAsFixed(0)}%',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          LinearProgressIndicator(
                                            value: progress,
                                            backgroundColor: Colors.grey[300],
                                            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tanggal: ${item.waktuPencapaian}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _tambahPencapaian,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Tambah",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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