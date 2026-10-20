
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final tema = PengaturanTema(
    modeGelap: prefs.getBool('modeGelap') ?? false,
    indeksWarna: prefs.getInt('indeksWarna') ?? 0,
  );

  runApp(Aplikasi(tema: tema));
}

// ==================== PENGATURAN TEMA ====================

class PengaturanTema extends ChangeNotifier {
  bool modeGelap;
  int indeksWarna;

  PengaturanTema({
    required this.modeGelap,
    required this.indeksWarna,
  });

  final List<Color> pilihanWarna = [
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
  ];

  Color get warnaTema => pilihanWarna[indeksWarna];

  ThemeMode get themeMode =>
      modeGelap ? ThemeMode.dark : ThemeMode.light;

  Future<void> ubahMode(bool nilai) async {
    modeGelap = nilai;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', nilai);

    notifyListeners();
  }

  Future<void> ubahWarna(int indeks) async {
    indeksWarna = indeks;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('indeksWarna', indeks);

    notifyListeners();
  }
}

// ==================== APLIKASI UTAMA ====================

class Aplikasi extends StatelessWidget {
  final PengaturanTema tema;

  const Aplikasi({
    super.key,
    required this.tema,
  });

  ThemeData buatTema(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: tema.warnaTema,
        brightness: brightness,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tema,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Galeri Tempat Wisata',
          theme: buatTema(Brightness.light),
          darkTheme: buatTema(Brightness.dark),
          themeMode: tema.themeMode,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => HalamanUtama(tema: tema),
              );
            }

            if (settings.name == '/detail') {
              final argumen = settings.arguments;

              if (argumen is TempatWisata) {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return HalamanDetail(item: argumen);
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                );
              }
            }

            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const Halaman404(),
            );
          },
        );
      },
    );
  }
}

// ==================== DATA TEMPAT WISATA ====================

class TempatWisata {
  final String id;
  final String nama;
  final String lokasi;
  final String deskripsi;
  final IconData ikon;

  const TempatWisata({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.ikon,
  });
}

const List<TempatWisata> daftarWisata = [
  TempatWisata(
    id: 'bali',
    nama: 'Pantai Bali',
    lokasi: 'Bali, Indonesia',
    deskripsi:
    'Bali terkenal dengan pantainya yang indah, pemandangan '
        'matahari terbenam, budaya yang menarik, dan suasana '
        'liburan yang menyenangkan.',
    ikon: Icons.beach_access,
  ),
  TempatWisata(
    id: 'bromo',
    nama: 'Gunung Bromo',
    lokasi: 'Jawa Timur, Indonesia',
    deskripsi:
    'Gunung Bromo menawarkan pemandangan pegunungan, '
        'lautan pasir, dan matahari terbit yang menjadi '
        'daya tarik wisatawan.',
    ikon: Icons.landscape,
  ),
  TempatWisata(
    id: 'borobudur',
    nama: 'Candi Borobudur',
    lokasi: 'Magelang, Jawa Tengah',
    deskripsi:
    'Candi Borobudur merupakan destinasi wisata sejarah '
        'dan budaya yang terkenal dengan bangunan candi '
        'serta reliefnya.',
    ikon: Icons.account_balance,
  ),
  TempatWisata(
    id: 'rajaampat',
    nama: 'Raja Ampat',
    lokasi: 'Papua Barat Daya, Indonesia',
    deskripsi:
    'Raja Ampat dikenal dengan pulau-pulau karst, air laut '
        'yang jernih, dan kekayaan kehidupan bawah laut.',
    ikon: Icons.sailing,
  ),
];

// ==================== HALAMAN UTAMA ====================

class HalamanUtama extends StatefulWidget {
  final PengaturanTema tema;

  const HalamanUtama({
    super.key,
    required this.tema,
  });

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int indeksTab = 0;

  @override
  Widget build(BuildContext context) {
    final judul = [
      'Galeri Wisata',
      'Daftar Wisata',
      'Pengaturan',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(judul[indeksTab]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.travel_explore,
                    size: 42,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Galeri Tempat Wisata',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Beranda'),
              selected: indeksTab == 0,
              onTap: () {
                setState(() => indeksTab = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeri'),
              selected: indeksTab == 1,
              onTap: () {
                setState(() => indeksTab = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Pengaturan'),
              selected: indeksTab == 2,
              onTap: () {
                setState(() => indeksTab = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: indeksTab,
        children: [
          const BerandaTab(),
          const GaleriTab(),
          HalamanPengaturan(tema: widget.tema),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indeksTab,
        onDestinationSelected: (indeks) {
          setState(() {
            indeksTab = indeks;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Galeri',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

// ==================== TAB BERANDA ====================

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: warna.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.explore,
                size: 48,
                color: warna.onPrimaryContainer,
              ),
              const SizedBox(height: 12),
              Text(
                'Jelajahi Indonesia!',
                style: teks.headlineSmall?.copyWith(
                  color: warna.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Temukan tempat wisata menarik dan lihat keindahan '
                    'berbagai destinasi Indonesia.',
                style: teks.bodyMedium?.copyWith(
                  color: warna.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Destinasi Pilihan',
          style: teks.titleLarge,
        ),
        const SizedBox(height: 12),
        ...daftarWisata.take(3).map(
              (item) => KartuWisata(item: item),
        ),
        const SizedBox(height: 24),
        Text(
          'Demo Animasi',
          style: teks.titleLarge,
        ),
        const SizedBox(height: 12),
        const DemoAnimasi(),
      ],
    );
  }
}

// ==================== TAB GALERI ====================

class GaleriTab extends StatelessWidget {
  const GaleriTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Semua Tempat Wisata',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...daftarWisata.map(
              (item) => KartuWisata(item: item),
        ),
      ],
    );
  }
}

// ==================== KARTU WISATA ====================

class KartuWisata extends StatelessWidget {
  final TempatWisata item;

  const KartuWisata({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail',
            arguments: item,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Hero(
                tag: 'wisata-${item.id}',
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: warna.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    item.ikon,
                    size: 40,
                    color: warna.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nama,
                      style: teks.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.lokasi,
                      style: teks.bodyMedium?.copyWith(
                        color: warna.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lihat detail',
                      style: teks.labelLarge?.copyWith(
                        color: warna.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== HALAMAN DETAIL ====================

class HalamanDetail extends StatelessWidget {
  final TempatWisata item;

  const HalamanDetail({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Wisata'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Hero(
            tag: 'wisata-${item.id}',
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                color: warna.secondaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                item.ikon,
                size: 100,
                color: warna.onSecondaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            item.nama,
            style: teks.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: warna.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.lokasi,
                  style: teks.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Tentang Tempat Ini',
            style: teks.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            item.deskripsi,
            style: teks.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali ke Galeri'),
          ),
        ],
      ),
    );
  }
}

// ==================== DEMO ANIMASI ====================

class DemoAnimasi extends StatefulWidget {
  const DemoAnimasi({super.key});

  @override
  State<DemoAnimasi> createState() => _DemoAnimasiState();
}

class _DemoAnimasiState extends State<DemoAnimasi>
    with SingleTickerProviderStateMixin {
  bool diperbesar = false;
  bool terlihat = true;

  late final AnimationController controller;
  late final Animation<double> rotasi;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    rotasi = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: diperbesar ? 180 : 120,
              height: diperbesar ? 120 : 80,
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                borderRadius: BorderRadius.circular(
                  diperbesar ? 32 : 12,
                ),
              ),
              child: Icon(
                Icons.landscape,
                size: diperbesar ? 64 : 44,
                color: warna.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Animasi implisit: ukuran dan bentuk',
              style: teks.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  diperbesar = !diperbesar;
                });
              },
              child: const Text('Ubah Ukuran'),
            ),
            const Divider(height: 28),
            AnimatedOpacity(
              opacity: terlihat ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: warna.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Pesona alam Indonesia',
                  textAlign: TextAlign.center,
                  style: teks.titleMedium?.copyWith(
                    color: warna.onTertiaryContainer,
                  ),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  terlihat = !terlihat;
                });
              },
              child: Text(
                terlihat ? 'Sembunyikan Kartu' : 'Tampilkan Kartu',
              ),
            ),
            const Divider(height: 28),
            RotationTransition(
              turns: rotasi,
              child: Icon(
                Icons.explore,
                size: 64,
                color: warna.primary,
              ),
            ),
            Text(
              'Animasi eksplisit: AnimationController',
              style: teks.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                if (controller.isAnimating) {
                  controller.stop();
                } else {
                  controller.forward(from: 0);
                }
              },
              child: const Text('Putar Ikon'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== HALAMAN PENGATURAN ====================

class HalamanPengaturan extends StatelessWidget {
  final PengaturanTema tema;

  const HalamanPengaturan({
    super.key,
    required this.tema,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Tema'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Mode Tampilan',
            style: teks.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: Icon(
                tema.modeGelap ? Icons.dark_mode : Icons.light_mode,
              ),
              title: const Text('Mode Gelap'),
              subtitle: const Text(
                'Pilihan ini tersimpan saat aplikasi ditutup.',
              ),
              value: tema.modeGelap,
              onChanged: (nilai) {
                tema.ubahMode(nilai);
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Warna Tema',
            style: teks.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih warna utama aplikasi.',
            style: teks.bodyMedium?.copyWith(
              color: warna.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<int>(
                  value: 0,
                  groupValue: tema.indeksWarna,
                  title: const Text('Indigo'),
                  secondary: const CircleAvatar(
                    backgroundColor: Colors.indigo,
                  ),
                  onChanged: (nilai) {
                    if (nilai != null) {
                      tema.ubahWarna(nilai);
                    }
                  },
                ),
                RadioListTile<int>(
                  value: 1,
                  groupValue: tema.indeksWarna,
                  title: const Text('Teal'),
                  secondary: const CircleAvatar(
                    backgroundColor: Colors.teal,
                  ),
                  onChanged: (nilai) {
                    if (nilai != null) {
                      tema.ubahWarna(nilai);
                    }
                  },
                ),
                RadioListTile<int>(
                  value: 2,
                  groupValue: tema.indeksWarna,
                  title: const Text('Deep Orange'),
                  secondary: const CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                  ),
                    onChanged: (nilai) {
                    if (nilai != null) {
                      tema.ubahWarna(nilai);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: warna.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tema pilihanmu disimpan menggunakan SharedPreferences.',
                style: teks.bodyLarge?.copyWith(
                  color: warna.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== HALAMAN 404 ====================

class Halaman404 extends StatelessWidget {
  const Halaman404({super.key});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Tidak Ditemukan'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: warna.error,
              ),
              const SizedBox(height: 16),
              Text(
                '404 - Halaman tidak ditemukan',
                textAlign: TextAlign.center,
                style: teks.headlineSmall,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                        (route) => false,
                  );
                },
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
