
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

// ==================== APLIKASI ====================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 5',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const CatatanPage(),
    );
  }
}

// ==================== MODEL CATATAN ====================

class Catatan {
  int? id;
  String judul;
  String isi;
  String? dibuat;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    this.dibuat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'dibuat': dibuat,
    };
  }

  factory Catatan.fromMap(Map<String, dynamic> map) {
    return Catatan(
      id: map['id'] as int?,
      judul: map['judul'] as String,
      isi: map['isi'] as String,
      dibuat: map['dibuat'] as String?,
    );
  }
}

// ==================== DATABASE ====================

class DbHelper {
  DbHelper._();

  static final DbHelper instance = DbHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final lokasi = p.join(
      await getDatabasesPath(),
      'catatan.db',
    );

    _database = await openDatabase(
      lokasi,
      version: 2,

      // Membuat tabel jika database belum ada.
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE catatan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            isi TEXT NOT NULL,
            dibuat TEXT
          )
        ''');
      },

      // Memperbarui database versi lama.
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          final kolom = await db.rawQuery(
            'PRAGMA table_info(catatan)',
          );

          final sudahAda = kolom.any(
                (item) => item['name'] == 'dibuat',
          );

          if (!sudahAda) {
            await db.execute(
              'ALTER TABLE catatan ADD COLUMN dibuat TEXT',
            );
          }
        }
      },
    );

    return _database!;
  }

  // Menampilkan dan mencari catatan.
  Future<List<Catatan>> semua({
    String kata = '',
    String urutan = 'DESC',
  }) async {
    final db = await database;

    final hasil = await db.query(
      'catatan',
      where: 'judul LIKE ?',
      whereArgs: ['%$kata%'],
      orderBy: 'dibuat $urutan',
    );

    return hasil.map((data) => Catatan.fromMap(data)).toList();
  }

  // Menambahkan catatan.
  Future<int> tambah(Catatan catatan) async {
    final db = await database;

    return db.insert(
      'catatan',
      {
        'judul': catatan.judul,
        'isi': catatan.isi,
        'dibuat': DateTime.now().toIso8601String(),
      },
    );
  }

  // Mengubah catatan.
  Future<int> ubah(Catatan catatan) async {
    final db = await database;

    return db.update(
      'catatan',
      {
        'judul': catatan.judul,
        'isi': catatan.isi,
      },
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
  }

  // Menghapus catatan.
  Future<int> hapus(int id) async {
    final db = await database;

    return db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// ==================== HALAMAN CATATAN ====================

class CatatanPage extends StatefulWidget {
  const CatatanPage({super.key});

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  final TextEditingController _cariController =
  TextEditingController();

  String _kata = '';
  String _urutan = 'DESC';

  @override
  void initState() {
    super.initState();
    _muatUrutan();
  }

  @override
  void dispose() {
    _cariController.dispose();
    super.dispose();
  }

  // Mengambil pilihan urutan yang tersimpan.
  Future<void> _muatUrutan() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _urutan = prefs.getString('urutanCatatan') ?? 'DESC';
    });
  }

  // Menyimpan pilihan urutan.
  Future<void> _simpanUrutan(String nilai) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('urutanCatatan', nilai);

    if (!mounted) return;

    setState(() {
      _urutan = nilai;
    });
  }

  // Dialog konfirmasi sebelum menghapus.
  Future<void> _konfirmasiHapus(int id) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Hapus catatan ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (yakin == true) {
      await DbHelper.instance.hapus(id);

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil dihapus'),
        ),
      );
    }
  }

  // Membuka halaman tambah atau edit.
  Future<void> _bukaForm([Catatan? catatan]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FormCatatanPage(catatan: catatan);
        },
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // Mengubah format tanggal.
  String _formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) {
      return 'Tanggal tidak tersedia';
    }

    final waktu = DateTime.tryParse(tanggal);

    if (waktu == null) {
      return 'Tanggal tidak tersedia';
    }

    final hari = waktu.day.toString().padLeft(2, '0');
    final bulan = waktu.month.toString().padLeft(2, '0');
    final jam = waktu.hour.toString().padLeft(2, '0');
    final menit = waktu.minute.toString().padLeft(2, '0');

    return '$hari/$bulan/${waktu.year} $jam:$menit';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kolom pencarian judul.
            TextField(
              controller: _cariController,
              decoration: InputDecoration(
                labelText: 'Cari judul catatan',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _cariController.clear();

                    setState(() {
                      _kata = '';
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (nilai) {
                setState(() {
                  _kata = nilai;
                });
              },
            ),

            const SizedBox(height: 12),

            // Pilihan urutan terbaru atau terlama.
            DropdownButtonFormField<String>(
              initialValue: _urutan,
              decoration: const InputDecoration(
                labelText: 'Urutan catatan',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'DESC',
                  child: Text('Terbaru'),
                ),
                DropdownMenuItem(
                  value: 'ASC',
                  child: Text('Terlama'),
                ),
              ],
              onChanged: (nilai) {
                if (nilai != null) {
                  _simpanUrutan(nilai);
                }
              },
            ),

            const SizedBox(height: 12),

            // Daftar catatan.
            Expanded(
              child: FutureBuilder<List<Catatan>>(
                future: DbHelper.instance.semua(
                  kata: _kata,
                  urutan: _urutan,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Terjadi kesalahan: ${snapshot.error}',
                      ),
                    );
                  }

                  final daftar = snapshot.data ?? [];

                  if (daftar.isEmpty) {
                    return const Center(
                      child: Text('Belum ada catatan'),
                    );
                  }

                  return ListView.builder(
                    itemCount: daftar.length,
                    itemBuilder: (context, index) {
                      final item = daftar[index];

                      return Card(
                        child: ListTile(
                          title: Text(
                            item.judul,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(item.isi),
                              const SizedBox(height: 6),
                              Text(
                                'Dibuat: ${_formatTanggal(item.dibuat)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          onTap: () {
                            _bukaForm(item);
                          },
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _konfirmasiHapus(item.id!);
                            },
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bukaForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==================== FORM TAMBAH DAN EDIT ====================

class FormCatatanPage extends StatefulWidget {
  final Catatan? catatan;

  const FormCatatanPage({
    super.key,
    this.catatan,
  });

  @override
  State<FormCatatanPage> createState() => _FormCatatanPageState();
}

class _FormCatatanPageState extends State<FormCatatanPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _judulController =
  TextEditingController();

  final TextEditingController _isiController =
  TextEditingController();

  bool _menyimpan = false;

  bool get _sedangEdit => widget.catatan != null;

  @override
  void initState() {
    super.initState();

    if (_sedangEdit) {
      _judulController.text = widget.catatan!.judul;
      _isiController.text = widget.catatan!.isi;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  // Menyimpan catatan baru atau perubahan.
  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _menyimpan = true;
    });

    try {
      final catatan = Catatan(
        id: widget.catatan?.id,
        judul: _judulController.text.trim(),
        isi: _isiController.text.trim(),
        dibuat: widget.catatan?.dibuat,
      );

      if (_sedangEdit) {
        await DbHelper.instance.ubah(catatan);
      } else {
        await DbHelper.instance.tambah(catatan);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _sedangEdit
                ? 'Catatan berhasil diubah'
                : 'Catatan berhasil ditambahkan',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan catatan: $e'),
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
          _sedangEdit ? 'Edit Catatan' : 'Tambah Catatan',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (nilai) {
                  if (nilai == null || nilai.trim().isEmpty) {
                    return 'Judul wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _isiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Isi catatan',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (nilai) {
                  if (nilai == null || nilai.trim().isEmpty) {
                    return 'Isi catatan wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _menyimpan ? null : _simpan,
                  child: _menyimpan
                      ? const CircularProgressIndicator()
                      : Text(
                    _sedangEdit
                        ? 'Simpan Perubahan'
                        : 'Simpan Catatan',
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
