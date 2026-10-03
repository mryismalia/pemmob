import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Barang {
  String nama;
  int jumlah;
  String kategori;
  bool sudahDibeli;

  Barang({
    required this.nama,
    required this.jumlah,
    required this.kategori,
    this.sudahDibeli = false,
  });
}

class BelanjaModel extends ChangeNotifier {
  final List<Barang> _items = [];

  List<Barang> get items => List.unmodifiable(_items);

  int get jumlahBelumDibeli {
    return _items.where((barang) => !barang.sudahDibeli).length;
  }

  void tambahBarang({
    required String nama,
    required int jumlah,
    required String kategori,
  }) {
    _items.add(Barang(nama: nama, jumlah: jumlah, kategori: kategori));

    notifyListeners();
  }

  void toggleDibeli(int index) {
    _items[index].sudahDibeli = !_items[index].sudahDibeli;

    notifyListeners();
  }

  void hapusBarang(int index) {
    _items.removeAt(index);

    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => BelanjaModel(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Belanja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.pink.shade50,
        useMaterial3: true,
      ),
      home: const DaftarBelanjaPage(),
    );
  }
}

class DaftarBelanjaPage extends StatelessWidget {
  const DaftarBelanjaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BelanjaModel>();

    return Scaffold(
      appBar: AppBar(title: Text('Belanja (${model.jumlahBelumDibeli})')),
      body: model.items.isEmpty
          ? const Center(
              child: Text('Belum ada barang', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: model.items.length,
              itemBuilder: (context, index) {
                final barang = model.items[index];

                return ListTile(
                  leading: Checkbox(
                    value: barang.sudahDibeli,
                    onChanged: (_) {
                      context.read<BelanjaModel>().toggleDibeli(index);
                    },
                  ),
                  title: Text(
                    barang.nama,
                    style: TextStyle(
                      decoration: barang.sudahDibeli
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text('${barang.jumlah} • ${barang.kategori}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<BelanjaModel>().hapusBarang(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahBelanjaPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahBelanjaPage extends StatefulWidget {
  const TambahBelanjaPage({super.key});

  @override
  State<TambahBelanjaPage> createState() => _TambahBelanjaPageState();
}

class _TambahBelanjaPageState extends State<TambahBelanjaPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();

  String? _kategori;

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nama = _namaController.text.trim();

    final jumlah = int.parse(_jumlahController.text.trim());

    context.read<BelanjaModel>().tambahBarang(
      nama: nama,
      jumlah: jumlah,
      kategori: _kategori!,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Belanja')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama barang',
                  hintText: 'Contoh: Beras',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama barang wajib diisi';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  hintText: 'Contoh: 2',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah wajib diisi';
                  }

                  final jumlah = int.tryParse(value.trim());

                  if (jumlah == null) {
                    return 'Jumlah harus berupa angka';
                  }

                  if (jumlah <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Makanan', child: Text('Makanan')),
                  DropdownMenuItem(value: 'Minuman', child: Text('Minuman')),
                  DropdownMenuItem(
                    value: 'Kebutuhan Rumah',
                    child: Text('Kebutuhan Rumah'),
                  ),
                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                ],
                onChanged: (value) {
                  setState(() {
                    _kategori = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori wajib dipilih';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
