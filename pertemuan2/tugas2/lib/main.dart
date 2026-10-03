import 'package:flutter/material.dart';

class Kontak {
  final String nama;
  final String nomorTelepon;
  final String email;

  const Kontak(
      this.nama,
      this.nomorTelepon,
      this.email,
      );
}

const daftarKontak = [
  Kontak(
    'Mery Ismalia',
    '08125347685',
    'mryismalia@gmail.com',
  ),
  Kontak(
    'Adelia rizky cantika',
    '08128968357',
    'adelia@gmail.com',
  ),
  Kontak(
    'yuliadhy',
    '081223127895',
    'adhy@gmail.com',
  ),
  Kontak(
    'karimun',
    '0818785643489',
    'karimun@gmail.com',
  ),
  Kontak(
    'Al fahri',
    '081875427789',
    'Alfahri@gmail.com',
  ),
  Kontak(
    'upri',
    '081987996424',
    'upri@gmail.com',
  ),
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Kontak',
      theme: ThemeData(
        colorSchemeSeed: Colors.pink.shade50,
        useMaterial3: true,
      ),
      home: const KontakPage(),
    );
  }
}

class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
      ),
      body: ListView.builder(
        itemCount: daftarKontak.length,
        itemBuilder: (context, index) {
          final kontak = daftarKontak[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  kontak.nama[0],
                ),
              ),
              title: Text(
                kontak.nama,
              ),
              subtitle: Text(
                kontak.nomorTelepon,
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailKontakPage(
                      kontak: kontak,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailKontakPage extends StatelessWidget {
  final Kontak kontak;

  const DetailKontakPage({
    super.key,
    required this.kontak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kontak'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                child: Text(
                  kontak.nama[0],
                  style: const TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                kontak.nama,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Nomor Telepon',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                kontak.nomorTelepon,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Email',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                kontak.email,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}