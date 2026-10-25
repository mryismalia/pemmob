# Praktikum Flutter Fundamental - Pertemuan 6

Repository ini berisi hasil praktikum Flutter Fundamental Pertemuan 6 dengan materi Tema, Routing dan Navigasi, serta Animasi pada Flutter.

Praktikum ini merupakan lanjutan dari Pertemuan 1 sampai 5. Materi berfokus pada pengaturan tema terang dan gelap, penggunaan warna tema, navigasi ant halaman, named routes, pengiriman argumen, serta penerapan animasi pada aplikasi. Pada akhir praktikum, mahasiswa membuat aplikasi Galeri atau Katalog Interaktif yang memiliki minimal tiga tab, halaman detail dengan Hero, animasi, dan pengaturan tema yang tersimpan.

## 📚 Materi Praktikum

Materi yang dipelajari dalam praktikum ini meliputi:

- Mengatur tema menggunakan `ThemeData`.
- Memahami `ThemeMode` untuk tema terang, gelap, dan sistem.
- Menggunakan `Theme.of(context)` untuk mengambil gaya tema.
- Menghindari penggunaan warna hard-coded pada teks dan latar.
- Memahami navigasi menggunakan `Navigator`.
- Menggunakan named routes.
- Mengirim argumen ke halaman detail.
- Menggunakan `onGenerateRoute`.
- Memahami `pushNamed()`, `pop()`, dan `pushReplacementNamed()`.
- Membuat navigasi tab bawah menggunakan `NavigationBar`.
- Menggunakan `IndexedStack` untuk mempertahankan state tab.
- Membuat animasi implisit menggunakan `AnimatedContainer` dan `AnimatedSwitcher`.
- Menggunakan `Hero` untuk transisi ant halaman.
- Membuat animasi eksplisit menggunakan `AnimationController`.
- Menyimpan pilihan tema dan warna menggunakan SharedPreferences.

## 🛠️ Tools yang Digunakan

- Flutter SDK
- Dart
- Android Studio atau Visual Studio Code
- Android Emulator atau perangkat Android
- Git dan GitHub
- Material Design 3
- SharedPreferences untuk penyimpanan pengaturan

## 📋 Prasyarat

Sebelum mengikuti praktikum ini, mahasiswa sudah menyelesaikan materi:

- Pertemuan 1: Widget dasar dan StatefulWidget.
- Pertemuan 2: Layout, ListView, dan navigasi.
- Pertemuan 3: Form input dan state management.
- Pertemuan 4: REST API, HTTP, dan asynchronous programming.
- Pertemuan 5: Penyimpanan data lokal menggunakan SharedPreferences dan SQLite.

## 🚀 Membuat Project

Project Flutter untuk Pertemuan 6 dapat dibuat menggunakan perintah:

```bash
flutter create praktikum_6
```

Masuk ke folder project:

```bash
cd praktikum_6
```

Jalankan aplikasi:

```bash
flutter run
```

Untuk praktikum dasar pada modul ini, tidak diperlukan package tambahan. SharedPreferences digunakan pada latihan mandiri untuk menyimpan pengaturan tema dan warna.

## 🎨 Tema Aplikasi dengan ThemeData

Tema digunakan untuk mengatur tampilan aplikasi secara konsisten, termasuk warna, tipografi, dan gaya komponen.

Flutter menyediakan `ThemeData` untuk menentukan gaya aplikasi. Dengan Material 3, palet warna dapat dibuat berdasarkan satu warna utama menggunakan `colorSchemeSeed`.

Contoh:

```dart
ThemeData(
  colorSchemeSeed: Colors.blue,
  useMaterial3: true,
)
```

Aplikasi juga dapat menyediakan tema terang dan gelap melalui properti `theme`, `darkTheme`, dan `themeMode` pada `MaterialApp`.

Tema terang digunakan ketika aplikasi berada dalam mode terang, sedangkan `darkTheme` digunakan ketika aplikasi berada dalam mode gelap. Properti `themeMode` menentukan tema yang sedang diterapkan.

## 🌗 Tema Terang dan Gelap

Pada praktikum, pengguna dapat mengganti tampilan aplikasi dari mode terang ke mode gelap dan sebaliknya.

Perubahan tema perlu diterapkan pada seluruh halaman, bukan hanya halaman pengaturan. Oleh karena itu, pengelolaan tema harus dilakukan pada tingkat aplikasi.

Ketika nilai tema berubah, tampilan aplikasi perlu dibangun kembali agar perubahan tersebut terlihat pada semua halaman.

Pada contoh praktikum, `ValueNotifier` digunakan untuk menyimpan pilihan tema dan `ListenableBuilder` digunakan agar `MaterialApp` diperbarui ketika nilai tema berubah.

## 🎨 Menggunakan Theme.of(context)

`Theme.of(context)` digunakan untuk mengambil tema yang sedang aktif pada widget.

Contoh mengambil warna utama:

```dart
final warnaUtama = Theme.of(context).colorScheme.primary;
```

Contoh mengambil warna latar:

```dart
final warnaLatar = Theme.of(context).colorScheme.surface;
```

Dengan menggunakan nilai tema, warna komponen dapat menyesuaikan mode terang atau gelap secara otomatis.

Penggunaan `Theme.of(context)` lebih konsisten dibandingkan menuliskan warna secara langsung pada setiap widget. Hal ini juga membantu menjaga keterbacaan teks ketika pengguna mengganti tema.

## 🧭 Navigasi dan Named Routes

Navigasi digunakan untuk berpindah dari satu halaman ke halaman lainnya.

Flutter menyediakan `Navigator` untuk mengatur perpindahan halaman. Selain menggunakan navigasi langsung, aplikasi dapat menggunakan named routes agar setiap halaman memiliki nama rute yang jelas.

Beberapa metode navigasi yang dipelajari:

| Metode | Fungsi |
|---|---|
| `Navigator.pushNamed()` | Membuka halaman berdasarkan nama rute dan dapat mengirim argumen. |
| `Navigator.pop()` | Menutup halaman yang sedang terbuka dan kembali ke halaman sebelumnya. |
| `Navigator.pushReplacementNamed()` | Mengganti halaman saat ini dengan halaman baru. |
| `Navigator.pushNamedAndRemoveUntil()` | Membuka halaman baru sambil menghapus halaman tertentu dari riwayat navigasi. |

Contoh membuka halaman detail:

```dart
Navigator.pushNamed(
  context,
  '/detail',
  arguments: data,
);
```

Pada contoh tersebut, `data` dikirim sebagai argumen ke halaman detail. Halaman tujuan kemudian membaca argumen tersebut untuk menampilkan informasi yang sesuai.

## 🛣️ onGenerateRoute

`onGenerateRoute` digunakan untuk menentukan halaman yang harus dibuka berdasarkan nama rute.

Fitur ini berguna ketika halaman membutuhkan argumen atau ketika aplikasi ingin mengatur proses pembuatan halaman secara terpusat.

Dengan named routes dan `onGenerateRoute`, perpindahan ke halaman detail dapat diatur tanpa menumpuk seluruh logika navigasi di dalam widget.

Nama rute harus sesuai dengan rute yang ditangani aplikasi. Jika nama rute salah atau belum ditangani, navigasi dapat menghasilkan error.

## 🧩 Navigasi Tab dengan NavigationBar

Pada bagian praktikum, dibuat `ShellPage` yang menampung tiga tab utama:

- Beranda.
- Animasi.
- Pengaturan.

Navigasi tab bawah dibuat menggunakan `NavigationBar`. Indeks tab aktif disimpan dalam state dan diperbarui ketika pengguna memilih tab lain.

`IndexedStack` digunakan untuk menampilkan halaman berdasarkan indeks yang dipilih.

Penggunaan `IndexedStack` membantu mempertahankan state setiap tab ketika pengguna berpindah halaman tab. Dengan demikian, halaman tidak harus selalu dibuat ulang hanya karena pengguna berpindah tab.

Contoh struktur navigasi:

```text
ShellPage
    |
    +---- Beranda
    |
    +---- Animasi
    |
    +---- Pengaturan
```

Beranda digunakan untuk menampilkan konten utama, tab Animasi berisi demo animasi, sedangkan tab Pengaturan digunakan untuk mengubah tema aplikasi.

## ✨ Animasi Implisit

Animasi implisit digunakan ketika perubahan nilai widget ingin dianimasikan secara otomatis.

Flutter menyediakan beberapa widget animasi implisit, seperti:

- `AnimatedContainer`
- `AnimatedOpacity`
- `AnimatedSwitcher`

`AnimatedContainer` dapat digunakan untuk menganimasikan perubahan ukuran, warna, atau properti dekorasi ketika nilainya berubah.

`AnimatedOpacity` digunakan untuk menganimasikan tingkat transparansi widget.

`AnimatedSwitcher` digunakan untuk memberikan transisi ketika widget anak berubah.

Contoh penggunaan `AnimatedContainer`:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  width: 150,
  height: 150,
  color: Colors.blue,
)
```

Contoh tersebut menunjukkan penggunaan durasi animasi selama 300 milidetik. Agar animasi terlihat, nilai yang dianimasikan perlu berubah, misalnya melalui `setState()`.

## 🖼️ Hero Animation

`Hero` digunakan untuk memberikan transisi visual pada elemen yang sama ketika berpindah dari satu halaman ke halaman lainnya.

Contohnya, gambar tempat wisata pada halaman beranda dapat terlihat bergerak menuju posisi gambar pada halaman detail.

Agar animasi Hero berjalan dengan benar, kedua widget `Hero` pada halaman asal dan halaman tujuan harus menggunakan nilai `tag` yang sama. Tag juga harus unik pada setiap halaman yang menampilkan Hero.

Contoh:

```dart
Hero(
  tag: 'wisata-1',
  child: Image.network(urlGambar),
)
```

Tag yang sama digunakan pada gambar yang sesuai di halaman detail agar Flutter dapat menghubungkan kedua elemen tersebut.

## 🎬 Animasi Eksplisit dengan AnimationController

Animasi eksplisit digunakan ketika animasi membutuhkan kontrol yang lebih lengkap, seperti mengatur pengulangan, menghentikan animasi, atau mengendalikan urutan gerakan.

Pada praktikum ini digunakan `AnimationController` bersama kelas animasi lainnya, misalnya `RotationTransition`.

`AnimationController` memerlukan `TickerProvider` untuk mengatur waktu animasi. Pada state widget, salah satu cara yang digunakan adalah `SingleTickerProviderStateMixin`.

Controller harus dilepas ketika widget tidak lagi digunakan agar tidak terus menggunakan sumber daya.

Contoh pola pelepasan controller:

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

## ⚙️ Menyimpan Tema dan Warna

Pada latihan mandiri, pilihan mode gelap dan warna tema disimpan menggunakan SharedPreferences.

Tujuannya agar pengaturan pengguna tidak kembali ke nilai awal ketika aplikasi ditutup dan dibuka kembali.

Latihan ini menggunakan materi penyimpanan lokal dari Pertemuan 5.

Ketika aplikasi dimulai, pengaturan yang telah disimpan perlu dibaca sebelum tampilan utama ditampilkan agar aplikasi dapat menggunakan tema pilihan pengguna sejak awal.

Pengaturan yang disimpan mencakup:

- Mode terang atau gelap.
- Pilihan warna tema dengan minimal tiga pilihan.

## 📱 Aplikasi Galeri atau Katalog Interaktif

Pada bagian akhir praktikum dibuat aplikasi Galeri atau Katalog Interaktif. Tema aplikasi bebas, misalnya profil diri, katalog produk, atau galeri tempat wisata.

### Halaman Beranda

Halaman beranda menampilkan konten utama, misalnya daftar gambar atau informasi tempat wisata.

Pengguna dapat memilih salah satu item untuk membuka halaman detail.

### Halaman Detail

Halaman detail menampilkan informasi lengkap dari item yang dipilih.

Halaman ini dibuka menggunakan named routes dengan argumen. Elemen gambar atau elemen visual yang sesuai menggunakan Hero untuk memberikan transisi dari halaman sebelumnya.

### Halaman Animasi

Halaman Animasi digunakan untuk menampilkan demo animasi implisit dan eksplisit.

Contoh animasi yang dapat ditampilkan adalah perubahan ukuran atau warna menggunakan `AnimatedContainer`, pergantian widget menggunakan `AnimatedSwitcher`, atau rotasi menggunakan `AnimationController`.

### Halaman Pengaturan

Halaman Pengaturan digunakan untuk mengubah mode terang dan gelap serta memilih warna tema.

Perubahan pengaturan harus memengaruhi tampilan seluruh aplikasi. Pilihan tema dan warna juga disimpan agar tetap tersedia setelah aplikasi ditutup.

## 🔁 Alur Aplikasi

```text
Aplikasi dimulai
       |
       v
Memuat pengaturan tema
       |
       v
ShellPage
       |
       +---- Beranda
       |       |
       |       v
       |   Pilih item
       |       |
       |       v
       |   Named Route
       |       |
       |       v
       |   Halaman Detail + Hero
       |
       +---- Animasi
       |       |
       |       v
       |   Animasi Implisit
       |   dan Eksplisit
       |
       +---- Pengaturan
               |
               v
        Ubah tema dan warna
               |
               v
        Simpan pengaturan
               |
               v
        Tampilan diperbarui
```

## 🏋️ Latihan Mandiri

Latihan mandiri pada Pertemuan 6 terdiri dari:

1. Menyimpan mode gelap dan warna tema menggunakan SharedPreferences, kemudian memuatnya ketika aplikasi dimulai.
2. Menambahkan Drawer pada `ShellPage` yang berisi menu untuk berpindah tab.
3. Mengganti transisi halaman detail dengan `PageRouteBuilder` yang menggunakan `FadeTransition` di dalam `onGenerateRoute`.
4. Menambahkan `onUnknownRoute` untuk menampilkan halaman "404 - Halaman tidak ditemukan".
5. Menambahkan demo keempat pada `AnimasiTab` menggunakan `AnimatedOpacity` untuk memudarkan dan memunculkan kartu ketika tombol ditekan.

## 🎓 Tugas Praktikum

Tugas pada Pertemuan 6 adalah membuat aplikasi Galeri atau Katalog Interaktif dengan ketentuan:

- Tema aplikasi bebas, misalnya profil diri, katalog produk, atau galeri tempat wisata.
- Memiliki minimal tiga tab menggunakan `NavigationBar`.
- Menggunakan named routes dengan argumen untuk halaman detail.
- Halaman detail menggunakan Hero.
- Memiliki minimal dua jenis animasi, yaitu satu animasi implisit dan satu animasi eksplisit menggunakan `AnimationController`.
- Menyediakan pengaturan tema terang dan gelap.
- Menyediakan minimal tiga pilihan warna tema.
- Menyimpan pilihan tema dan warna agar tetap tersedia setelah aplikasi ditutup.
- Menggunakan `Theme.of(context)` untuk warna dan gaya teks.
- Menghindari warna hard-coded pada teks dan latar agar tampilan mengikuti tema.
- Mengumpulkan tangkapan layar mode terang, mode gelap, dan halaman detail.
- Mengumpulkan berkas kode atau tautan repositori.

Aplikasi ini juga menjadi bahan awal untuk mini proyek pada Pertemuan 7.

## 📊 Rubrik Penilaian

| Komponen | Bobot |
|---|---:|
| Bagian A–D berjalan (checkpoint) | 30% |
| Latihan mandiri | 20% |
| Tugas Galeri/Katalog Interaktif | 40% |
| Kerapian kode dan konsistensi penggunaan tema | 10% |
| **Total** | **100%** |

## ❓ Pertanyaan Refleksi

Beberapa pertanyaan yang dibahas setelah praktikum:

1. Apa perbedaan animasi implisit dan eksplisit? Kapan masing-masing digunakan?
2. Mengapa dua Hero harus memiliki tag yang sama, dan apa yang terjadi jika tag muncul dua kali pada halaman yang sama?
3. Apa keuntungan menggunakan `Theme.of(context)` dibandingkan menulis warna langsung pada widget?
4. Apa perbedaan berpindah tab menggunakan `IndexedStack` dengan membuka halaman menggunakan `Navigator`?
5. Mengapa `AnimationController` wajib di-dispose?

## 🔧 Troubleshooting

| Masalah | Solusi |
|---|---|
| Could not find a generator for route | Periksa nama rute dan pastikan rute sudah ditangani melalui `routes` atau `onGenerateRoute`. |
| Hero tidak beranimasi | Pastikan tag Hero sama pada kedua halaman dan unik pada setiap halaman. |
| Tema tidak berubah saat saklar digeser | Pastikan perubahan nilai tema memicu pembangunan ulang `MaterialApp`, misalnya melalui `ListenableBuilder`. |
| Sebagian warna tidak mengikuti mode gelap | Ganti warna yang ditulis manual dengan nilai dari `Theme.of(context).colorScheme`. |
| AnimatedContainer tidak beranimasi | Pastikan nilai yang dianimasikan berubah melalui `setState()` dan kedua nilai memiliki tipe yang sesuai. |
| AnimatedSwitcher tidak beranimasi | Pastikan widget anak memiliki key yang berbeda ketika terjadi pergantian. |
| Error vsync atau TickerProvider | Gunakan `SingleTickerProviderStateMixin` pada state yang mengelola `AnimationController`. |

## 📖 Referensi

- [Tema Aplikasi - Flutter](https://docs.flutter.dev/cookbook/design/themes)
- [Named Routes - Flutter](https://docs.flutter.dev/cookbook/navigation/named-routes)
- [Pengantar Animasi - Flutter](https://docs.flutter.dev/ui/animations)
- [Hero Animations - Flutter](https://docs.flutter.dev/ui/animations/hero-animations)
- [Package SharedPreferences](https://pub.dev/packages/shared_preferences)

## 👩‍💻 Praktikum

Mata Kuliah: Pemrograman Mobile / Flutter Fundamental

Pertemuan: 6

Topik: Tema, Routing dan Navigasi, serta Animasi
