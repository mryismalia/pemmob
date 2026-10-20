
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

const List<String> kategoriList = [
  'Makanan',
  'Transportasi',
  'Belanja',
  'Pendidikan',
  'Kesehatan',
  'Hiburan',
  'Lainnya',
];

// ==================== MODEL ====================

class Pengeluaran {
  int? id;
  String nama;
  int jumlah;
  String kategori;
  String tanggal;

  Pengeluaran({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jumlah': jumlah,
      'kategori': kategori,
      'tanggal': tanggal,
    };
  }

  factory Pengeluaran.fromMap(Map<String, dynamic> map) {
    return Pengeluaran(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      jumlah: map['jumlah'] as int,
      kategori: map['kategori'] as String,
      tanggal: map['tanggal'] as String,
    );
  }
}

// ==================== DATABASE SQLITE ====================

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final lokasi = p.join(
      await getDatabasesPath(),
      'pengeluaran.db',
    );

    _database = await openDatabase(
      lokasi,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pengeluaran (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            jumlah INTEGER NOT NULL,
            kategori TEXT NOT NULL,
            tanggal TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<List<Pengeluaran>> semua() async {
    final db = await database;

    final hasil = await db.query(
      'pengeluaran',
      orderBy: 'id DESC',
    );

    return hasil
        .map((data) => Pengeluaran.fromMap(data))
        .toList();
  }

  Future<int> tambah(Pengeluaran data) async {
    final db = await database;
    return db.insert('pengeluaran', data.toMap());
  }

  Future<int> ubah(Pengeluaran data) async {
    final db = await database;

    return db.update(
      'pengeluaran',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> hapus(int id) async {
    final db = await database;

    return db.delete(
      'pengeluaran',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> total() async {
    final db = await database;

    final hasil = await db.rawQuery(
      'SELECT SUM(jumlah) AS total FROM pengeluaran',
    );

    return (hasil.first['total'] as int?) ?? 0;
  }
}

// ==================== APLIKASI ====================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _modeGelap = false;

  @override
  void initState() {
    super.initState();
    _muatTema();
  }

  Future<void> _muatTema() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _modeGelap = prefs.getBool('modeGelap') ?? false;
    });
  }

  Future<void> _ubahTema(bool nilai) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', nilai);

    if (!mounted) return;

    setState(() {
      _modeGelap = nilai;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Pengeluaran',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness:
        _modeGelap ? Brightness.dark : Brightness.light,
        useMaterial3: true,
      ),
      home: PengeluaranPage(
        modeGelap: _modeGelap,
        ubahTema: _ubahTema,
      ),
    );
  }
}

// ==================== HALAMAN UTAMA ====================

class PengeluaranPage extends StatefulWidget {
  final bool modeGelap;
  final ValueChanged<bool> ubahTema;

  const PengeluaranPage({
    super.key,
    required this.modeGelap,
    required this.ubahTema,
  });

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  Future<List<Pengeluaran>>? _data;
  Future<int>? _total;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  void _muatData() {
    _data = DatabaseHelper.instance.semua();
    _total = DatabaseHelper.instance.total();
  }

  void _segarkan() {
    setState(() {
      _muatData();
    });
  }

  String _rupiah(int angka) {
    final teks = angka.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < teks.length; i++) {
      buffer.write(teks[i]);

      final sisa = teks.length - i - 1;
      if (sisa > 0 && sisa % 3 == 0) {
        buffer.write('.');
      }
    }

    return 'Rp$buffer';
  }

  String _formatTanggal(String tanggal) {
    final waktu = DateTime.tryParse(tanggal);
    if (waktu == null) return tanggal;

    return '${waktu.day.toString().padLeft(2, '0')}/'
        '${waktu.month.toString().padLeft(2, '0')}/'
        '${waktu.year}';
  }

  Future<void> _bukaForm([Pengeluaran? data]) async {
    final berhasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FormPengeluaranPage(data: data),
      ),
    );

    if (berhasil == true && mounted) {
      _segarkan();
    }
  }

  Future<void> _konfirmasiHapus(Pengeluaran data) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus pengeluaran "${data.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      await DatabaseHelper.instance.hapus(data.id!);

      if (!mounted) return;

      _segarkan();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengeluaran berhasil dihapus'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Pengeluaran'),
        actions: [
          IconButton(
            tooltip: 'Mode gelap',
            icon: Icon(
              widget.modeGelap
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              widget.ubahTema(!widget.modeGelap);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Total pengeluaran.
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Pengeluaran'),
                const SizedBox(height: 8),
                FutureBuilder<int>(
                  future: _total,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Gagal menghitung total');
                    }

                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    return Text(
                      _rupiah(snapshot.data!),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Pengeluaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: FutureBuilder<List<Pengeluaran>>(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi kesalahan: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final daftar = snapshot.data!;

                if (daftar.isEmpty) {
                  return const Center(
                    child: Text('Belum ada pengeluaran'),
                  );
                }

                return ListView.builder(
                  itemCount: daftar.length,
                  itemBuilder: (context, index) {
                    final data = daftar[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            data.kategori == 'Makanan'
                                ? Icons.restaurant
                                : data.kategori == 'Transportasi'
                                ? Icons.directions_car
                                : Icons.receipt_long,
                          ),
                        ),
                        title: Text(
                          data.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${data.kategori} • '
                              '${_formatTanggal(data.tanggal)}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _rupiah(data.jumlah),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => _bukaForm(data),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: () =>
                                      _konfirmasiHapus(data),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==================== FORM PENGELUARAN ====================

class FormPengeluaranPage extends StatefulWidget {
  final Pengeluaran? data;

  const FormPengeluaranPage({
    super.key,
    this.data,
  });

  @override
  State<FormPengeluaranPage> createState() =>
      _FormPengeluaranPageState();
}

class _FormPengeluaranPageState
    extends State<FormPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController =
  TextEditingController();

  final TextEditingController _jumlahController =
  TextEditingController();

  String? _kategori;

  bool _menyimpan = false;

  bool get _sedangEdit => widget.data != null;

  @override
  void initState() {
    super.initState();

    if (_sedangEdit) {
      _namaController.text = widget.data!.nama;
      _jumlahController.text = widget.data!.jumlah.toString();
      _kategori = widget.data!.kategori;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _menyimpan = true;
    });

    try {
      final data = Pengeluaran(
        id: widget.data?.id,
        nama: _namaController.text.trim(),
        jumlah: int.parse(_jumlahController.text.trim()),
        kategori: _kategori!,
        tanggal: widget.data?.tanggal ??
            DateTime.now().toIso8601String(),
      );

      if (_sedangEdit) {
        await DatabaseHelper.instance.ubah(data);
      } else {
        await DatabaseHelper.instance.tambah(data);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _menyimpan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _sedangEdit
              ? 'Ubah Pengeluaran'
              : 'Tambah Pengeluaran',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama pengeluaran',
                  hintText: 'Contoh: Makan siang',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(),
                ),
                validator: (nilai) {
                  if (nilai == null || nilai.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah (Rp)',
                  hintText: 'Contoh: 25000',
                  prefixIcon: Icon(Icons.payments),
                  border: OutlineInputBorder(),
                ),
                validator: (nilai) {
                  if (nilai == null || nilai.trim().isEmpty) {
                    return 'Jumlah wajib diisi';
                  }

                  final jumlah = int.tryParse(nilai.trim());

                  if (jumlah == null) {
                    return 'Jumlah harus berupa angka bulat';
                  }

                  if (jumlah <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: kategoriList.map((kategori) {
                  return DropdownMenuItem<String>(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (nilai) {
                  setState(() {
                    _kategori = nilai;
                  });
                },
                validator: (nilai) {
                  if (nilai == null || nilai.isEmpty) {
                    return 'Kategori wajib dipilih';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _menyimpan ? null : _simpan,
                  icon: const Icon(Icons.save),
                  label: Text(
                    _menyimpan
                        ? 'Menyimpan...'
                        : 'Simpan Pengeluaran',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
