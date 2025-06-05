import 'package:flutter/material.dart';
import '../jadwal/jadwal_page.dart';
import '../user/profil_page.dart';
import '../user/teman_list_page.dart';
import '../pencapaian/HalamanPencapaian.dart';
import '../kegiatan/Kegiatan.dart';
import '../kegiatan/tambahKegiatan.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String username = 'Argantara';
  int count = 0;
  int count1 = 0;

  void tambah() {
    setState(() {
      count++;
    });
  }

  void tambah1() {
    setState(() {
      count1++;
    });
  }

  void dropuptambah(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SizedBox(
          height: 175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TambahKegiatan()),
                  );
                },
                child: const Text("Tambah Kegiatan"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Tambah Jadwal"),
              ),
            ],
          ),
        );
      },
    );
  }

  void dropupmenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Profil"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TemanListPage()),
                  );
                },
                child: const Text("Teman"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pencapaian()),
                  );
                },
                child: const Text("Pencapaian"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageKegiatan()),
                  );
                },
                child: const Text("Kegiatan"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double paddingdaftar = 5;

    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Colors.white,
        //       Colors.white,
        //       Colors.deepPurple
        //     ]
        //   )
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // kartu profil
            Container(
              height: 140,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilPage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage('assets/images/profil.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '${widget.email}',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$username',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, color: Colors.white),
                ],
              ),
            ),

            // Kegiatan Terkini
            Container(
              // color: Colors.deepPurple,
              // width: double.infinity,
              padding: const EdgeInsets.only(left: 30, bottom: 5, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Kegiatan Terkini:',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            // daftar kegiatan
            Container(
              height: 75,
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.all(paddingdaftar),
              decoration: BoxDecoration(
                color: const Color.fromARGB(50, 104, 58, 183),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '10.30',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.deepPurple[400],
                        ),
                      ),
                      Icon(Icons.school, color: Colors.deepPurple[400]),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Kelas Bahasa Inggris',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[100],
                          foregroundColor: Colors.deepPurple[400],
                        ),
                        child: Text(
                          'selesai',
                          style: TextStyle(color: Colors.deepPurple[400]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 75,
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.all(paddingdaftar),
              decoration: BoxDecoration(
                color: const Color.fromARGB(50, 104, 58, 183),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '12.30',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.deepPurple[400],
                        ),
                      ),
                      Icon(Icons.school, color: Colors.deepPurple[400]),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Kelas Agama',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[100],
                          foregroundColor: Colors.deepPurple[400],
                        ),
                        child: Text(
                          'selesai',
                          style: TextStyle(color: Colors.deepPurple[400]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 75,
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.all(paddingdaftar),
              decoration: BoxDecoration(
                color: const Color.fromARGB(50, 104, 58, 183),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '14.30',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.deepPurple[400],
                        ),
                      ),
                      Icon(Icons.book_sharp, color: Colors.deepPurple[400]),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belajar Mandiri',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[100],
                          foregroundColor: Colors.deepPurple[400],
                        ),
                        child: Text(
                          'selesai',
                          style: TextStyle(color: Colors.deepPurple[400]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // pencapaianmu
            Container(
              padding: const EdgeInsets.only(left: 30, bottom: 5, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Pencapaianmu:', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            // daftar pencapaianmu
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: tambah,
                    child: Container(
                      height: 125,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 40,
                            color: Colors.red,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('$count', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: tambah1,
                    child: Container(
                      height: 125,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.book, size: 40, color: Colors.amber),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('$count1', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Navbar bawah
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.deepPurple,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JadwalPage()),
                  );
                },
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  dropupmenu(context);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(0, 5),
        child: FloatingActionButton(
          onPressed: () {
            dropuptambah(context);
          },
          backgroundColor: Colors.white,
          hoverColor: Colors.white70,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.deepPurple),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
