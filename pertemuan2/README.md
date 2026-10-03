# Praktikum Flutter Fundamental - Pertemuan 2

Repository ini berisi hasil praktikum **Flutter Fundamental Pertemuan 2** dengan materi **Layout, ListView, dan Navigasi Antar Halaman**.

Praktikum ini merupakan lanjutan dari Pertemuan 1 dan berfokus pada pembuatan layout yang lebih terstruktur, menampilkan data dalam bentuk daftar, membuat model data sederhana menggunakan class Dart, serta melakukan navigasi antar halaman.

## 📚 Materi Praktikum

Materi yang dipelajari dalam praktikum ini meliputi:

1. Membuat layout menggunakan `Container`
2. Mengatur jarak menggunakan `Padding`
3. Menyusun widget menggunakan `Row` dan `Column`
4. Menggunakan `Expanded`
5. Memahami `mainAxisAlignment` dan `crossAxisAlignment`
6. Menampilkan data menggunakan `ListView.builder`
7. Menggunakan `Card` dan `ListTile`
8. Membuat model data menggunakan class Dart
9. Menampilkan daftar data dari sebuah List
10. Melakukan navigasi menggunakan `Navigator.push`
11. Mengirim data dari halaman daftar ke halaman detail
12. Kembali ke halaman sebelumnya menggunakan `Navigator.pop`

## 🛠️ Tools yang Digunakan

* Flutter SDK
* Dart
* Android Studio / Visual Studio Code
* Android Emulator atau perangkat Android
* Git & GitHub

## 📋 Prasyarat

Sebelum mengikuti praktikum ini, mahasiswa sudah menyelesaikan materi **Pertemuan 1**, terutama:

* Instalasi Flutter
* Widget dasar
* `StatefulWidget`
* Menjalankan aplikasi Flutter

## 🚀 Membuat Project

Project Flutter untuk Pertemuan 2 dapat dibuat menggunakan:

```bash
flutter create praktikum_2
```

Kemudian masuk ke folder project:

```bash
cd praktikum_2
```

Jalankan aplikasi dengan:

```bash
flutter run
```

## 🧩 Materi Layout

Pada bagian pertama praktikum dibuat sebuah **Kartu Profil** menggunakan beberapa widget layout.

Widget yang digunakan:

| Widget         | Fungsi                                                                          |
| -------------- | ------------------------------------------------------------------------------- |
| `Container`    | Membuat kotak dan mengatur ukuran, warna, border, radius, padding, serta margin |
| `Padding`      | Memberikan jarak di sekitar widget                                              |
| `Row`          | Menyusun widget secara horizontal                                               |
| `Column`       | Menyusun widget secara vertikal                                                 |
| `Expanded`     | Membuat widget mengisi sisa ruang yang tersedia                                 |
| `CircleAvatar` | Menampilkan avatar berbentuk lingkaran                                          |

Contoh struktur layout:

```text
Scaffold
└── Padding
    └── Container
        └── Row
            ├── CircleAvatar
            ├── SizedBox
            └── Expanded
                └── Column
                    ├── Text (Nama)
                    └── Text (NIM)
```

`Expanded` digunakan agar bagian teks dapat menyesuaikan ruang yang tersedia di dalam `Row`.

## 📐 Main Axis dan Cross Axis

Pada Flutter, `Row` dan `Column` memiliki dua sumbu layout.

### Row

```text
Main Axis   → Horizontal
Cross Axis  ↓ Vertikal
```

### Column

```text
Main Axis   ↓ Vertikal
Cross Axis  → Horizontal
```

Perataan widget dapat diatur menggunakan:

```dart
mainAxisAlignment
crossAxisAlignment
```

## 📋 Model Data

Pada bagian kedua, dibuat model data sederhana menggunakan class Dart.

Contohnya:

```dart
class Makanan {
  final String nama;
  final int harga;

  const Makanan(this.nama, this.harga);
}
```

Kemudian dibuat daftar menu:

```dart
const daftarMenu = [
  Makanan('Nasi Goreng', 15000),
  Makanan('Mie Ayam', 12000),
  Makanan('Es Teh', 4000),
  Makanan('Ayam Bakar', 20000),
];
```

Dengan cara ini, setiap data makanan memiliki `nama` dan `harga`.

## 📜 ListView.builder

`ListView.builder` digunakan untuk menampilkan data dalam bentuk daftar yang dapat di-scroll.

Pada praktikum ini digunakan bersama:

* `ListView.builder`
* `Card`
* `ListTile`

Contoh:

```dart
ListView.builder(
  itemCount: daftarMenu.length,
  itemBuilder: (context, index) {
    final item = daftarMenu[index];

    return Card(
      child: ListTile(
        leading: const Icon(Icons.restaurant),
        title: Text(item.nama),
        subtitle: Text('Rp ${item.harga}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  },
)
```

Hasilnya adalah daftar menu yang dapat di-scroll dan setiap menu ditampilkan dalam bentuk kartu.

## 🧭 Navigasi Antar Halaman

Praktikum juga membahas cara berpindah dari halaman daftar menuju halaman detail.

Navigasi dilakukan menggunakan:

```dart
Navigator.push()
```

Contohnya:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => DetailPage(makanan: item),
  ),
);
```

Data makanan dikirim ke halaman detail melalui constructor:

```dart
class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({
    super.key,
    required this.makanan,
  });
}
```

Untuk kembali ke halaman sebelumnya digunakan:

```dart
Navigator.pop(context);
```

Dengan demikian alur aplikasi menjadi:

```text
Halaman Daftar Menu
        │
        │ pilih menu
        ▼
Halaman Detail
        │
        │ tombol Kembali
        ▼
Halaman Daftar Menu
```

## 🏋️ Latihan Mandiri

Latihan pada praktikum ini terdiri dari:

1. Menambahkan 3 menu baru ke dalam `daftarMenu`.
2. Menambahkan properti `deskripsi` pada class `Makanan`.
3. Menampilkan deskripsi pada `DetailPage`.
4. Mengganti `Card` dengan `Container` yang memiliki warna latar dan sudut membulat.
5. Membuat fungsi untuk menampilkan harga dengan format ribuan, contohnya `15.000`.

## 🎓 Tugas Praktikum

Tugas pada Pertemuan 2 adalah membuat aplikasi **Daftar Kontak**.

Ketentuan aplikasi:

* Minimal 6 kontak.
* Setiap kontak memiliki:

  * Nama
  * Nomor telepon
  * Email
* Data disimpan dalam `List` yang berisi objek dari sebuah class.
* Halaman utama menampilkan daftar kontak menggunakan `ListView.builder`.
* Setiap kontak menggunakan `ListTile`.
* Avatar menampilkan huruf pertama dari nama.
* Ketika kontak ditekan, aplikasi membuka halaman detail.
* Halaman detail menampilkan seluruh data kontak.
* Tersedia tombol untuk kembali ke halaman sebelumnya.

Pengumpulan berupa:

* Screenshot halaman daftar kontak.
* Screenshot halaman detail kontak.
* File `main.dart` atau link repository GitHub.

## 📊 Rubrik Penilaian

| Komponen                         |    Bobot |
| -------------------------------- | -------: |
| Bagian A-C berjalan / checkpoint |      40% |
| Latihan mandiri                  |      20% |
| Tugas Daftar Kontak              |      30% |
| Kerapian kode dan penamaan       |      10% |
| **Total**                        | **100%** |

## ❓ Pertanyaan Refleksi

Pertanyaan yang dibahas setelah praktikum:

1. Apa perbedaan `ListView` biasa dengan `ListView.builder`?
2. Mengapa `Row` yang berisi teks panjang dapat menyebabkan overflow?
3. Bagaimana `Expanded` membantu mengatasi masalah tersebut?
4. Bagaimana data dikirim dari halaman daftar ke halaman detail?

## 🔧 Troubleshooting

| Masalah                                            | Solusi                                                       |
| -------------------------------------------------- | ------------------------------------------------------------ |
| Garis kuning-hitam / overflow                      | Gunakan `Expanded` atau `SingleChildScrollView`              |
| `ListView` tidak memiliki tinggi di dalam `Column` | Bungkus `ListView` dengan `Expanded`                         |
| Navigator error                                    | Pastikan halaman berada di bawah `MaterialApp`               |
| Perubahan tidak muncul                             | Gunakan Hot Restart jika mengubah `main()` atau data `const` |

## 📖 Referensi

* [Flutter Layout](https://docs.flutter.dev/ui/layout)
* [Flutter Lists Cookbook](https://docs.flutter.dev/cookbook/lists)
* [Flutter Navigation Cookbook](https://docs.flutter.dev/cookbook/navigation)

## 👩‍💻 Praktikum

**Mata Kuliah:** Pemrograman Mobile / Flutter Fundamental
**Pertemuan:** 2
**Topik:** Layout, ListView, dan Navigasi Antar Halaman
