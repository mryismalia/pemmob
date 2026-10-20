import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<Color> pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

const List<String> namaWarna = ['Indigo', 'Teal', 'Oranye', 'Pink'];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final modeGelap = prefs.getBool('modeGelap') ?? false;
  final indeksWarna = prefs.getInt('warnaTema') ?? 0;

  final indeksAman = indeksWarna >= 0 && indeksWarna < pilihanWarna.length
      ? indeksWarna
      : 0;

  final tema = AplikasiTema(
    mode: modeGelap ? ThemeMode.dark : ThemeMode.light,
    warna: pilihanWarna[indeksAman],
  );

  runApp(Aplikasi(tema: tema));
}

class AplikasiTema extends ChangeNotifier {
  ThemeMode mode;
  Color warna;

  AplikasiTema({required this.mode, required this.warna});

  Future<void> ubahMode(bool gelap) async {
    mode = gelap ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', gelap);

    notifyListeners();
  }

  Future<void> ubahWarna(Color warnaBaru) async {
    warna = warnaBaru;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('warnaTema', pilihanWarna.indexOf(warnaBaru));

    notifyListeners();
  }
}

ThemeData buatTema(Color warna, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: warna, brightness: brightness),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

class Aplikasi extends StatelessWidget {
  final AplikasiTema tema;

  const Aplikasi({super.key, required this.tema});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tema,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Praktikum 6',
          theme: buatTema(tema.warna, Brightness.light),
          darkTheme: buatTema(tema.warna, Brightness.dark),
          themeMode: tema.mode,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(
                builder: (context) {
                  return ShellPage(tema: tema);
                },
              );
            }

            if (settings.name == '/detail') {
              final item = settings.arguments;

              if (item is Item) {
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return HalamanDetail(item: item);
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                );
              }
            }

            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (context) => const Halaman404());
          },
        );
      },
    );
  }
}

class Item {
  final String judul;
  final String deskripsi;
  final IconData ikon;
  final Color warna;

  const Item({
    required this.judul,
    required this.deskripsi,
    required this.ikon,
    required this.warna,
  });
}

const List<Item> daftarItem = [
  Item(
    judul: 'Gunung',
    deskripsi:
        'Pemandangan gunung yang indah dengan udara sejuk dan alam yang asri.',
    ikon: Icons.landscape,
    warna: Colors.green,
  ),
  Item(
    judul: 'Laut',
    deskripsi:
        'Pemandangan laut dengan air biru dan suasana pantai yang menenangkan.',
    ikon: Icons.water,
    warna: Colors.blue,
  ),
  Item(
    judul: 'Bunga',
    deskripsi:
        'Berbagai bunga dengan warna menarik yang memperindah lingkungan.',
    ikon: Icons.local_florist,
    warna: Colors.pink,
  ),
];

class ShellPage extends StatefulWidget {
  final AplikasiTema tema;

  const ShellPage({super.key, required this.tema});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int indeksTab = 0;

  void pilihTab(int indeks) {
    setState(() {
      indeksTab = indeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final halaman = [
      const BerandaTab(),
      const AnimasiTab(),
      PengaturanTab(tema: widget.tema),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Galeri Sederhana')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.photo_library, size: 42),
                  SizedBox(height: 8),
                  Text(
                    'Menu Navigasi',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
                pilihTab(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('Animasi'),
              onTap: () {
                Navigator.pop(context);
                pilihTab(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                pilihTab(2);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: indeksTab, children: halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indeksTab,
        onDestinationSelected: pilihTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation_outlined),
            selectedIcon: Icon(Icons.animation),
            label: 'Animasi',
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

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Selamat Datang!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text('Pilih koleksi berikut untuk melihat detailnya.'),
        const SizedBox(height: 16),
        ...daftarItem.map((item) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Hero(
                tag: item.judul,
                child: CircleAvatar(
                  backgroundColor: item.warna.withValues(alpha: 0.15),
                  child: Icon(item.ikon, color: item.warna, size: 30),
                ),
              ),
              title: Text(item.judul),
              subtitle: Text(
                item.deskripsi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/detail', arguments: item);
              },
            ),
          );
        }),
      ],
    );
  }
}

class HalamanDetail extends StatelessWidget {
  final Item item;

  const HalamanDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.judul)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: item.judul,
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: item.warna.withValues(alpha: 0.15),
                  child: Icon(item.ikon, size: 75, color: item.warna),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                item.judul,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                item.deskripsi,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab>
    with SingleTickerProviderStateMixin {
  bool diperbesar = false;
  bool tampilIkon = true;
  bool tampilKartu = true;

  late final AnimationController controller;
  late final Animation<double> animasiPutar;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animasiPutar = Tween<double>(begin: 0, end: 1).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Contoh Animasi',
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 20),
        const Text('1. AnimatedContainer'),
        const SizedBox(height: 12),

        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: diperbesar ? 200 : 120,
            height: diperbesar ? 150 : 100,
            decoration: BoxDecoration(
              color: diperbesar
                  ? Colors.deepOrange
                  : Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(diperbesar ? 30 : 8),
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 45),
          ),
        ),

        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            setState(() {
              diperbesar = !diperbesar;
            });
          },
          child: const Text('Ubah Ukuran dan Warna'),
        ),

        const Divider(height: 36),
        const Text('2. AnimatedSwitcher'),
        const SizedBox(height: 12),

        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              tampilIkon ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(tampilIkon),
              size: 90,
              color: Colors.pink,
            ),
          ),
        ),

        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            setState(() {
              tampilIkon = !tampilIkon;
            });
          },
          child: const Text('Ganti Ikon'),
        ),

        const Divider(height: 36),
        const Text('3. AnimationController'),
        const SizedBox(height: 12),

        Center(
          child: RotationTransition(
            turns: animasiPutar,
            child: const Icon(Icons.settings, size: 80, color: Colors.teal),
          ),
        ),

        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            if (controller.isAnimating) {
              controller.stop();
            } else {
              controller.repeat();
            }
          },
          child: const Text('Putar / Berhenti'),
        ),

        TextButton(
          onPressed: () {
            controller.reset();
          },
          child: const Text('Reset Animasi'),
        ),

        const Divider(height: 36),
        const Text('4. AnimatedOpacity'),
        const SizedBox(height: 12),

        Center(
          child: AnimatedOpacity(
            opacity: tampilKartu ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Card(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.photo, size: 50),
                      const SizedBox(height: 8),
                      Text(
                        'Kartu Animasi',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Kartu memudar dan muncul kembali.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            setState(() {
              tampilKartu = !tampilKartu;
            });
          },
          child: Text(tampilKartu ? 'Sembunyikan Kartu' : 'Tampilkan Kartu'),
        ),
      ],
    );
  }
}

class PengaturanTab extends StatelessWidget {
  final AplikasiTema tema;

  const PengaturanTab({super.key, required this.tema});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Pengaturan Tampilan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        SwitchListTile(
          title: const Text('Mode Gelap'),
          subtitle: const Text('Pilihan disimpan secara otomatis'),
          value: tema.mode == ThemeMode.dark,
          onChanged: tema.ubahMode,
        ),

        const Divider(height: 32),
        const Text(
          'Pilih Warna Tema',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ...List.generate(pilihanWarna.length, (indeks) {
          final warna = pilihanWarna[indeks];

          return RadioListTile<Color>(
            title: Text(namaWarna[indeks]),
            value: warna,
            groupValue: tema.warna,
            activeColor: warna,
            secondary: CircleAvatar(backgroundColor: warna, radius: 14),
            onChanged: (nilai) {
              if (nilai != null) {
                tema.ubahWarna(nilai);
              }
            },
          );
        }),
      ],
    );
  }
}

class Halaman404 extends StatelessWidget {
  const Halaman404({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80),
              const SizedBox(height: 16),
              const Text(
                '404 - Halaman tidak ditemukan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
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
