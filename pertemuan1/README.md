# Praktikum Flutter Fundamental - Pertemuan 1

Repository ini berisi hasil praktikum **Flutter Fundamental Pertemuan 1** dengan materi **Pengenalan Flutter, Instalasi, dan Aplikasi Pertama**.

Praktikum ini ditujukan untuk pemula dan membahas dasar-dasar Flutter dan Dart, mulai dari proses instalasi hingga membuat aplikasi Flutter sederhana menggunakan widget.

## 📚 Materi Praktikum

Materi yang dipelajari dalam praktikum ini meliputi:

1. Pengenalan Flutter dan Dart
2. Instalasi Flutter SDK
3. Konfigurasi Android Studio dan Android SDK
4. Verifikasi instalasi menggunakan `flutter doctor`
5. Membuat project Flutter pertama
6. Menjalankan aplikasi pada emulator/perangkat Android
7. Mengenal struktur folder project Flutter
8. Memahami konsep Widget
9. Menggunakan `StatelessWidget`
10. Menggunakan `StatefulWidget`
11. Menggunakan `setState()`
12. Memahami dan menggunakan Hot Reload
13. Membuat layout sederhana menggunakan `Column`, `Center`, `Text`, `Icon`, dan `SizedBox`
14. Membuat aplikasi Counter sederhana
15. Membuat aplikasi Kartu Perkenalan

## 🛠️ Tools yang Digunakan

* Flutter SDK
* Dart
* Android Studio / Visual Studio Code
* Android SDK
* Android Emulator atau perangkat Android
* Git & GitHub

## 📋 Persyaratan

Sesuai dengan modul, perangkat yang digunakan minimal memiliki:

* RAM 8 GB
* Ruang penyimpanan 10 GB
* Flutter SDK versi stabil
* Android Studio atau VS Code
* Emulator Android atau HP Android
* Koneksi internet

## 🚀 Instalasi dan Verifikasi

Setelah Flutter SDK dan Android Studio terpasang, lakukan pengecekan menggunakan:

```bash
flutter doctor
```

Untuk menerima lisensi Android:

```bash
flutter doctor --android-licenses
```

Pastikan hasil `flutter doctor` menunjukkan bahwa Flutter, Android toolchain, dan editor sudah dapat digunakan.

## 📱 Membuat Project Flutter

Project pertama dibuat menggunakan perintah:

```bash
flutter create praktikum_1
```

Masuk ke folder project:

```bash
cd praktikum_1
```

Kemudian jalankan aplikasi:

```bash
flutter run
```

Setelah berhasil dijalankan, aplikasi akan menampilkan aplikasi **Counter bawaan Flutter**. Tombol `+` dapat digunakan untuk menambah angka.

## 📁 Struktur Project

Beberapa bagian penting dalam project Flutter:

| File/Folder     | Fungsi                                     |
| --------------- | ------------------------------------------ |
| `lib/main.dart` | Titik masuk dan kode utama aplikasi        |
| `pubspec.yaml`  | Konfigurasi project, dependency, dan asset |
| `android/`      | Konfigurasi/platform Android               |
| `ios/`          | Konfigurasi/platform iOS                   |
| `test/`         | Berkas untuk pengujian                     |

## 🧩 Konsep Widget

file:///C:/Users/Mery%20Ismalia/Downloads/modul-praktikum-flutter-pertemuan-2.pdf

Flutter menggunakan konsep **Widget** sebagai dasar untuk membangun tampilan aplikasi.

Beberapa widget yang dipelajari:

* `MaterialApp`
* `Scaffold`
* `AppBar`
* `Center`
* `Text`
* `Column`
* `Icon`
* `SizedBox`

Contoh struktur widget:

```text
MaterialApp
└── Scaffold
    ├── AppBar
    └── Center
        └── Text
```

Struktur tersebut disebut sebagai **Widget Tree**.

## 🔹 StatelessWidget

`StatelessWidget` digunakan untuk widget yang tampilannya tidak memiliki perubahan state.

Contohnya digunakan pada aplikasi **Hello Flutter** untuk menampilkan nama mahasiswa.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello Flutter'),
        ),
        body: const Center(
          child: Text('Halo, nama saya [NAMA]!'),
        ),
      ),
    );
  }
}
```

## 🔄 StatefulWidget

`StatefulWidget` digunakan ketika tampilan aplikasi dapat berubah berdasarkan state.

Pada praktikum ini digunakan untuk membuat aplikasi Counter.

```dart
int _count = 0;
```

Nilai tersebut kemudian diubah menggunakan:

```dart
setState(() {
  _count++;
});
```

Dengan `setState()`, Flutter akan memperbarui tampilan ketika nilai `_count` berubah.

## 🔥 Hot Reload

Hot Reload digunakan untuk melihat perubahan kode secara langsung tanpa harus menjalankan ulang aplikasi dari awal.

Contohnya ketika mengubah nama pada aplikasi:

```dart
Text('Halo, nama saya Mery!')
```

Setelah kode disimpan, perubahan dapat langsung terlihat pada aplikasi melalui Hot Reload.

## 🏋️ Latihan Mandiri

Pada bagian latihan mandiri, terdapat beberapa pengembangan aplikasi Counter:

1. Mengubah warna `AppBar` dan warna teks.
2. Menambahkan tombol `remove` untuk mengurangi angka.
3. Menambahkan tombol reset untuk mengembalikan angka menjadi `0`.
4. Mencegah angka menjadi negatif.

## 🎓 Tugas Praktikum

Tugas pada pertemuan pertama adalah membuat aplikasi **Kartu Perkenalan** dalam satu halaman.

Aplikasi harus menampilkan:

* Foto atau ikon
* Nama
* NIM
* Jurusan
* Hobi

Widget yang digunakan:

```text
Column
Text
Icon
SizedBox
```

Hasil tugas dikumpulkan berupa screenshot aplikasi yang sudah berjalan dan link repository GitHub atau file `main.dart`.

## 📊 Rubrik Penilaian

| Komponen                              |    Bobot |
| ------------------------------------- | -------: |
| Instalasi berhasil (`flutter doctor`) |      20% |
| Checkpoint Bagian B-F                 |      40% |
| Latihan mandiri                       |      20% |
| Tugas Kartu Perkenalan                |      20% |
| **Total**                             | **100%** |

## ❓ Pertanyaan Refleksi

Beberapa pertanyaan yang dibahas setelah praktikum:

1. Apa perbedaan `StatelessWidget` dan `StatefulWidget`?
2. Mengapa perubahan variabel `_count` perlu menggunakan `setState()`?
3. Apa keuntungan Hot Reload dibandingkan rebuild penuh?

## 🔧 Troubleshooting

| Masalah                        | Solusi                                                  |
| ------------------------------ | ------------------------------------------------------- |
| `flutter` tidak dikenali       | Periksa PATH kemudian buka kembali terminal             |
| Lisensi Android belum diterima | Jalankan `flutter doctor --android-licenses`            |
| Emulator lambat                | Aktifkan virtualisasi VT-x/AMD-V pada BIOS              |
| Perangkat tidak terdeteksi     | Aktifkan USB debugging dan cek dengan `flutter devices` |

## 📖 Referensi

* [Flutter Documentation](https://docs.flutter.dev/)
* [Dart Language Tour](https://dart.dev/language)
* [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

## 👩‍💻 Praktikum

**Mata Kuliah:** Pemrograman Mobile / Flutter Fundamental
**Pertemuan:** 1
**Topik:** Pengenalan Flutter, Instalasi, dan Aplikasi Pertama
