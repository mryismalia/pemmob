# Praktikum Flutter Pertemuan 5
## Penyimpanan Data Lokal dengan SharedPreferences dan SQLite

### Deskripsi
Praktikum ini membahas penyimpanan data secara lokal pada aplikasi Flutter menggunakan SharedPreferences dan SQLite. SharedPreferences digunakan untuk menyimpan pengaturan sederhana, sedangkan SQLite digunakan untuk menyimpan data yang membutuhkan operasi CRUD.

### Tujuan
1. Memahami konsep penyimpanan data lokal.
2. Menggunakan SharedPreferences untuk menyimpan pengaturan.
3. Menggunakan SQLite untuk menyimpan data aplikasi.
4. Mengimplementasikan operasi Create, Read, Update, dan Delete (CRUD).
5. Memahami validasi input dan pengelolaan data lokal.

### Teknologi yang Digunakan
- Flutter
- Dart
- SharedPreferences
- SQLite
- Package `sqflite`
- Package `path`

### Persiapan
Jalankan perintah berikut pada terminal di folder proyek:

```bash
flutter pub get
flutter run
```

Pastikan package yang diperlukan sudah ditambahkan pada `pubspec.yaml`, termasuk `shared_preferences`, `sqflite`, dan `path`.

### Deskripsi Tugas
Membuat aplikasi **Pencatat Pengeluaran** untuk mencatat dan mengelola pengeluaran sehari-hari menggunakan database lokal.

### Struktur Data
Data pengeluaran mencakup kolom berikut:

| Kolom | Keterangan |
|---|---|
| `id` | Identitas pengeluaran |
| `nama` | Nama pengeluaran |
| `jumlah` | Nominal pengeluaran |
| `kategori` | Kategori pengeluaran |
| `tanggal` | Tanggal pengeluaran |

### Fitur Aplikasi
1. Menambahkan data pengeluaran.
2. Menampilkan daftar pengeluaran.
3. Mengubah data pengeluaran.
4. Menghapus data pengeluaran.
5. Memvalidasi input sebelum disimpan.
6. Menampilkan total pengeluaran.
7. Menyimpan data pengeluaran menggunakan SQLite.
8. Menyimpan pengaturan aplikasi menggunakan SharedPreferences.
9. Memastikan data tetap tersedia setelah aplikasi ditutup dan dibuka kembali.

### Pengujian
1. Tambahkan beberapa data pengeluaran.
2. Pastikan data muncul pada daftar.
3. Ubah salah satu data dan periksa hasilnya.
4. Hapus salah satu data.
5. Uji validasi ketika input belum lengkap atau tidak sesuai.
6. Periksa apakah total pengeluaran dihitung dengan benar.
7. Tutup dan buka kembali aplikasi untuk memastikan data tetap tersimpan.
8. Ubah pengaturan aplikasi dan periksa apakah pengaturan tersebut tetap tersimpan setelah aplikasi dibuka kembali.

### Hasil yang Diharapkan
Aplikasi dapat mengelola data pengeluaran melalui operasi CRUD, menghitung total pengeluaran, melakukan validasi input, dan mempertahankan data serta pengaturan secara lokal.

### Kesimpulan
Praktikum ini memberikan pemahaman tentang penggunaan SQLite dan SharedPreferences untuk menyimpan data dan pengaturan aplikasi Flutter secara lokal.
