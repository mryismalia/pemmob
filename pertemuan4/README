# Praktikum Flutter Pertemuan 4
## REST API, HTTP, dan Asynchronous Programming

### Deskripsi
Praktikum ini membahas cara mengambil dan menampilkan data dari REST API menggunakan Flutter. Materi mencakup penggunaan HTTP, asynchronous programming, `Future`, dan `FutureBuilder` untuk menampilkan data dari server.

### Tujuan
1. Memahami konsep REST API.
2. Menggunakan package `http` untuk mengambil data dari API.
3. Membuat model data menggunakan `fromJson`.
4. Memahami penggunaan `Future` dan `FutureBuilder`.
5. Menangani status loading dan error pada aplikasi.

### Teknologi yang Digunakan
- Flutter
- Dart
- Package `http`
- API JSONPlaceholder

### Persiapan
Pastikan Flutter sudah terpasang dan proyek telah dibuat.

Jalankan perintah berikut pada terminal di folder proyek:

```bash
flutter pub get
flutter run
```

Tambahkan package HTTP pada file `pubspec.yaml` jika belum tersedia:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
```

### Deskripsi Tugas
Membuat aplikasi **Daftar Postingan** yang mengambil data dari REST API JSONPlaceholder.

API yang digunakan:

- Daftar postingan: `https://jsonplaceholder.typicode.com/posts`
- Komentar postingan: `https://jsonplaceholder.typicode.com/posts/{id}/comments`

### Fitur Aplikasi
1. Menampilkan daftar postingan dari REST API.
2. Menampilkan detail postingan ketika dipilih.
3. Menampilkan komentar pada halaman detail.
4. Menggunakan model `Post` dan `Komentar` dengan metode `fromJson`.
5. Memisahkan kode pengambilan data dari kode tampilan UI.
6. Menampilkan indikator loading ketika data sedang dimuat.
7. Menampilkan pesan error apabila pengambilan data gagal.
8. Menyediakan tombol **Coba Lagi** untuk mengulangi pengambilan data.

### Pengujian
1. Jalankan aplikasi dan pastikan daftar postingan muncul.
2. Pilih salah satu postingan.
3. Pastikan halaman detail menampilkan isi postingan dan komentar.
4. Periksa tampilan ketika data sedang dimuat.
5. Uji penanganan error dan tombol Coba Lagi.

### Hasil yang Diharapkan
Aplikasi dapat mengambil data dari REST API, menampilkan daftar postingan beserta detail dan komentarnya, serta menangani kondisi loading dan error dengan baik.

### Kesimpulan
Praktikum ini memberikan pemahaman mengenai integrasi REST API pada Flutter, pengolahan data JSON, dan penggunaan asynchronous programming untuk membangun aplikasi yang mengambil data dari server.
