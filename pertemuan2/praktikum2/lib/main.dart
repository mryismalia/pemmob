import 'package:flutter/material.dart';

class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;

  const Makanan(this.nama, this.harga, this.deskripsi);
}

const daftarMenu = [
  Makanan('Nasi Goreng', 15000, 'nasi goreng lezat dengan sayuran,telur, dan acar'),
  Makanan('Mie Ayam', 12000, 'mie ayam dengan toping ayam dan ceker'),
  Makanan('Es Teh', 4000, 'es teh dengan pilihan teh yang terbaik dan sehat'),
  Makanan('Ayam Bakar', 20000, 'ayam bakar dengan rasa yang manis'),
  Makanan('sate taichan', 30000, 'sate yang di sajikan dengan sambal dan kaldu jamur'),
  Makanan('matcha', 25000, 'minuman teh hijau bubuk dengan rasa sepat seperti rumput'),
  Makanan('cimol bojot', 10000,  'makanan yang terbuat dari adonan teping aci yang di bulat-bulat'),
];

String formatHarga(int harga) {
  return harga
      .toString()
      .replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match match) => '${match.group(1)}.',
  );
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Menu',
      theme: ThemeData(
        colorSchemeSeed: Colors.pink,
        useMaterial3: true,
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu'),
      ),
      body: ListView.builder(
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];

          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.restaurant),
              title: Text(item.nama),
              subtitle: Text('Rp ${formatHarga(item.harga)}'),
              trailing: const Icon(Icons.chevron_right),

              // Navigasi ke halaman detail
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      makanan: item,
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

class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({
    super.key,
    required this.makanan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(makanan.nama),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant_menu,
              size: 80,
            ),

            const SizedBox(height: 16),

            Text(
              makanan.nama,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),

            Text('Rp ${makanan.harga}'),

            const SizedBox(height: 24),

            Text(
              makanan.deskripsi,
              textAlign: TextAlign.center,
            ),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}