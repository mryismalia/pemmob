# Praktikum Flutter Fundamental - Pertemuan 3

Repository ini berisi hasil praktikum **Flutter Fundamental Pertemuan 3** dengan materi **Form Input dan State Management**.

Praktikum ini merupakan lanjutan dari Pertemuan 1 dan 2. Materi berfokus pada cara mengambil input pengguna, membuat form dengan validasi, serta mengelola state yang digunakan oleh beberapa widget atau halaman menggunakan **Provider**.

## 📚 Materi Praktikum

Materi yang dipelajari dalam praktikum ini meliputi:

1. Mengambil input menggunakan `TextField`
2. Menggunakan `TextEditingController`
3. Membuat form menggunakan `Form`
4. Melakukan validasi menggunakan `TextFormField`
5. Menggunakan `DropdownButtonFormField`
6. Menggunakan `CheckboxListTile`
7. Memahami state lokal dengan `setState()`
8. Memahami keterbatasan `setState()` untuk data yang digunakan banyak halaman
9. Mengenal state management dengan `ChangeNotifier`
10. Menggunakan package `Provider`
11. Menggunakan `context.watch()`
12. Menggunakan `context.read()`
13. Membuat aplikasi Daftar Tugas
14. Berbagi state antar halaman menggunakan Provider

## 🛠️ Tools yang Digunakan

* Flutter SDK
* Dart
* Android Studio / Visual Studio Code
* Android Emulator atau perangkat Android
* Git & GitHub
* Package `provider`

## 📋 Prasyarat

Sebelum mengikuti praktikum ini, mahasiswa sudah menyelesaikan materi:

* Pertemuan 1: Widget dasar dan `StatefulWidget`
* Pertemuan 2: Layout, `ListView`, dan navigasi

## 🚀 Membuat Project

Project Flutter untuk Pertemuan 3 dapat dibuat menggunakan:

```bash
flutter create praktikum_3
```

Masuk ke folder project:

```bash
cd praktikum_3
```

Jalankan aplikasi:

```bash
flutter run
```

## ✏️ Input Dasar dengan TextField

Pada bagian pertama praktikum dibuat halaman input sederhana menggunakan `TextField`.

`TextEditingController` digunakan untuk mengambil nilai yang dimasukkan oleh pengguna.

Contoh:

```dart
final _controller = TextEditingController();
```

Kemudian controller digunakan pada `TextField`:

```dart
TextField(
  controller: _controller,
  decoration: const InputDecoration(
    labelText: 'Nama',
    border: OutlineInputBorder(),
  ),
)
```

Nilai input dapat diambil menggunakan:

```dart
_controller.text
```

Pada contoh praktikum, nama yang dimasukkan akan ditampilkan sebagai sapaan setelah tombol **Sapa** ditekan.

## 🧹 Dispose TextEditingController

`TextEditingController` harus dilepas ketika widget sudah tidak digunakan.

Caranya menggunakan:

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

Hal ini dilakukan agar controller tidak menyebabkan penggunaan memori yang tidak diperlukan.

## 📝 Form dan Validasi

Pada bagian berikutnya dibuat form pendaftaran menggunakan:

* `Form`
* `GlobalKey<FormState>`
* `TextFormField`
* `DropdownButtonFormField`
* `CheckboxListTile`

Form memiliki beberapa input:

* Nama lengkap
* Email
* Jurusan
* Persetujuan ketentuan

Validasi dilakukan menggunakan properti `validator`.

Contoh validasi nama:

```dart
validator: (v) =>
    (v == null || v.trim().isEmpty)
        ? 'Nama wajib diisi'
        : null,
```

Validasi email:

```dart
validator: (v) {
  if (v == null || !v.contains('@')) {
    return 'Email tidak valid';
  }

  return null;
}
```

Untuk menjalankan validasi seluruh form:

```dart
if (_formKey.currentState!.validate()) {
  // Form valid
}
```

## ☑️ Checkbox dan Dropdown

Dropdown digunakan untuk memilih jurusan:

```text
Teknik Informatika
Sistem Informasi
Teknik Elektro
```

Sedangkan `CheckboxListTile` digunakan untuk persetujuan ketentuan.

Tombol **Daftar** hanya dapat digunakan setelah checkbox persetujuan dicentang.

Jika input tidak valid, akan muncul pesan error. Jika semua input valid, aplikasi menampilkan `SnackBar`.

## 🔄 State Management

Pada bagian sebelumnya, state dikelola menggunakan `setState()`.

Cara tersebut cukup untuk state yang hanya digunakan pada satu halaman. Namun, ketika data perlu digunakan oleh beberapa halaman, penggunaan `setState()` dan pengiriman data melalui constructor atau callback dapat menjadi lebih rumit.

Karena itu, pada praktikum ini diperkenalkan **State Management menggunakan Provider**.

## 📦 Provider

Package Provider ditambahkan menggunakan:

```bash
flutter pub add provider
```

Provider digunakan bersama `ChangeNotifier` untuk menyimpan dan mengelola state aplikasi.

Contoh model:

```dart
class TugasModel extends ChangeNotifier {
  final List<Tugas> _items = [];

  List<Tugas> get items => List.unmodifiable(_items);

  int get jumlahSelesai =>
      _items.where((t) => t.selesai).length;
}
```

Ketika data berubah, digunakan:

```dart
notifyListeners();
```

`notifyListeners()` akan memberi tahu widget yang menggunakan state bahwa terdapat perubahan data.

## 👀 context.watch()

`context.watch<T>()` digunakan untuk membaca state sekaligus membuat widget ikut diperbarui ketika state berubah.

Contoh:

```dart
final model = context.watch<TugasModel>();
```

Biasanya digunakan di dalam `build()` ketika tampilan perlu mengikuti perubahan data.

## 📖 context.read()

`context.read<T>()` digunakan untuk membaca state tanpa membuat widget ikut melakukan rebuild ketika data berubah.

Contohnya digunakan pada callback:

```dart
context.read<TugasModel>().toggle(i);
```

atau:

```dart
context.read<TugasModel>().hapus(i);
```

Perbedaan sederhananya:

| Perintah          | Fungsi                                        |
| ----------------- | --------------------------------------------- |
| `context.watch()` | Membaca state dan rebuild ketika data berubah |
| `context.read()`  | Membaca state tanpa rebuild                   |

## ✅ Aplikasi Daftar Tugas

Pada bagian akhir praktikum dibuat aplikasi **Daftar Tugas**.

Aplikasi terdiri dari:

### Halaman Daftar

Menampilkan:

* Daftar tugas
* Checkbox untuk menandai tugas selesai
* Jumlah tugas selesai pada AppBar
* Tombol hapus
* Tombol tambah tugas

### Halaman Tambah Tugas

Digunakan untuk menambahkan tugas baru.

Data tugas yang ditambahkan dari halaman kedua akan langsung muncul pada halaman daftar karena kedua halaman menggunakan `TugasModel` yang sama melalui Provider.

Alur aplikasi:

```text
Halaman Daftar Tugas
        │
        │ Tombol +
        ▼
Halaman Tambah Tugas
        │
        │ Simpan
        ▼
TugasModel
        │
        │ notifyListeners()
        ▼
Halaman Daftar Tugas diperbarui
```

## 🏋️ Latihan Mandiri

Latihan pada Pertemuan 3 terdiri dari:

1. Menambahkan validasi pada `TambahPage` dengan ketentuan judul minimal 3 karakter.
2. Menambahkan method `hapusSelesai()` pada `TugasModel`.
3. Menambahkan tombol untuk menghapus semua tugas yang sudah selesai.
4. Menampilkan `SnackBar` **"Tugas ditambahkan"** setelah tugas disimpan.
5. Menampilkan teks **"Belum ada tugas"** ketika daftar masih kosong.

## 🎓 Tugas Praktikum

Tugas pada Pertemuan 3 adalah membuat aplikasi **Daftar Belanja**.

Aplikasi memiliki dua halaman utama.

### Halaman Form Tambah

Form harus memiliki:

* Nama barang
* Jumlah barang
* Kategori barang

Setiap input harus memiliki validasi.

Ketentuan:

* Nama barang wajib diisi.
* Jumlah wajib diisi.
* Jumlah harus berupa angka lebih dari 0.
* Kategori menggunakan dropdown.

### Halaman Daftar

Halaman daftar harus dapat:

* Menampilkan semua barang.
* Menandai barang sebagai **sudah dibeli**.
* Menghapus barang.
* Menampilkan jumlah barang yang belum dibeli pada AppBar.

State aplikasi harus disimpan dalam satu `ChangeNotifier` dan dibagikan menggunakan **Provider**.

## 📊 Rubrik Penilaian

| Komponen                   |    Bobot |
| -------------------------- | -------: |
| Bagian A-D / Checkpoint    |      35% |
| Latihan mandiri            |      20% |
| Tugas Daftar Belanja       |      35% |
| Kerapian kode dan penamaan |      10% |
| **Total**                  | **100%** |

## ❓ Pertanyaan Refleksi

Beberapa pertanyaan yang dibahas setelah praktikum:

1. Mengapa `TextEditingController` harus di-`dispose()`?
2. Kapan cukup menggunakan `setState()` dan kapan sebaiknya menggunakan Provider?
3. Apa yang terjadi jika `notifyListeners()` tidak dipanggil?
4. Mengapa pada `onPressed` digunakan `context.read()` dan bukan `context.watch()`?

## 🔧 Troubleshooting

| Masalah                                     | Solusi                                                                                          |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `Could not find the correct Provider`       | Pastikan `ChangeNotifierProvider` berada di atas `MaterialApp`                                  |
| Tampilan tidak berubah setelah data berubah | Pastikan `notifyListeners()` dipanggil dan widget menggunakan `context.watch()` atau `Consumer` |
| Package `provider` tidak ditemukan          | Jalankan `flutter pub get` dan restart aplikasi                                                 |
| `validate()` tidak bereaksi                 | Pastikan `Form` memiliki `key: _formKey` dan menggunakan `TextFormField`                        |
| Keyboard menyebabkan overflow               | Gunakan `ListView` atau `SingleChildScrollView` sebagai induk form                              |

## 📖 Referensi

* [Flutter Forms](https://docs.flutter.dev/cookbook/forms)
* [Flutter State Management](https://docs.flutter.dev/data-and-backend/state-mgmt)
* [Provider Package](https://pub.dev/packages/provider)

## 👩‍💻 Praktikum

**Mata Kuliah:** Pemrograman Mobile / Flutter Fundamental
**Pertemuan:** 3
**Topik:** Form Input dan State Management
