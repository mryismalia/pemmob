import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Pengaturan pengujian
// const bool ujiGalatDaftar = false;
const bool ujiGalatDaftar = true;
//const bool ujiGalatKomentar = false;
const bool ujiGalatKomentar = true;

void main() {
  runApp(const MyApp());
}

// APLIKASI UTAMA
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Postingan',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const PostPage(),
    );
  }
}

// MODEL POST
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

// MODEL KOMENTAR
class Komentar {
  final int id;
  final int postId;
  final String name;
  final String email;
  final String body;

  const Komentar({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      id: json['id'] as int,
      postId: json['postId'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }
}

// SERVICE API
class ApiService {
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com';

  // Mengambil daftar postingan
  static Future<List<Post>> ambilPostingan() async {
    if (ujiGalatDaftar) {
      throw Exception('Pengujian galat daftar postingan');
    }

    final response = await http
        .get(Uri.parse('$baseUrl/posts'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil postingan '
            '(kode ${response.statusCode})',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map(
          (item) => Post.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  // Mengambil komentar berdasarkan ID postingan
  static Future<List<Komentar>> ambilKomentar(
      int postId,
      ) async {
    if (ujiGalatKomentar) {
      throw Exception('Pengujian galat komentar');
    }

    final response = await http
        .get(
      Uri.parse('$baseUrl/posts/$postId/comments'),
    )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil komentar '
            '(kode ${response.statusCode})',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map(
          (item) => Komentar.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}

// WIDGET GALAT
class GalatWidget extends StatelessWidget {
  final String pesan;
  final VoidCallback onCobaLagi;

  const GalatWidget({
    super.key,
    required this.pesan,
    required this.onCobaLagi,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 56,
            ),
            const SizedBox(height: 12),
            const Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pesan,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onCobaLagi,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

// HALAMAN DAFTAR POSTINGAN
class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late Future<List<Post>> _futurePostingan;

  @override
  void initState() {
    super.initState();
    _muatPostingan();
  }

  void _muatPostingan() {
    _futurePostingan = ApiService.ambilPostingan();
  }

  void _cobaLagi() {
    setState(() {
      _muatPostingan();
    });
  }

  String potonganIsi(String isi) {
    if (isi.length > 100) {
      return '${isi.substring(0, 100)}...';
    }

    return isi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Postingan'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _cobaLagi,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _futurePostingan,
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // GALAT
          if (snapshot.hasError) {
            return GalatWidget(
              pesan: '${snapshot.error}',
              onCobaLagi: _cobaLagi,
            );
          }

          // DATA KOSONG
          final postingan = snapshot.data ?? [];

          if (postingan.isEmpty) {
            return const Center(
              child: Text('Tidak ada postingan'),
            );
          }

          // DAFTAR POSTINGAN
          return RefreshIndicator(
            onRefresh: () async {
              final request = ApiService.ambilPostingan();

              setState(() {
                _futurePostingan = request;
              });

              try {
                await request;
              } catch (_) {
                // FutureBuilder akan menampilkan galat.
              }
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: postingan.length,
              itemBuilder: (context, index) {
                final post = postingan[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      child: Text('${post.id}'),
                    ),
                    title: Text(
                      post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        potonganIsi(post.body),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPostPage(
                            post: post,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// HALAMAN DETAIL POSTINGAN
class DetailPostPage extends StatefulWidget {
  final Post post;

  const DetailPostPage({
    super.key,
    required this.post,
  });

  @override
  State<DetailPostPage> createState() =>
      _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  late Future<List<Komentar>> _futureKomentar;

  @override
  void initState() {
    super.initState();
    _muatKomentar();
  }

  void _muatKomentar() {
    _futureKomentar = ApiService.ambilKomentar(
      widget.post.id,
    );
  }

  void _cobaLagi() {
    setState(() {
      _muatKomentar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Postingan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // JUDUL
          Text(
            post.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text('Postingan #${post.id}'),
          const Divider(height: 32),

          // ISI LENGKAP
          Text(
            'Isi Postingan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            post.body,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),

          // KOMENTAR
          Text(
            'Komentar',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // FUTURE KEDUA
          FutureBuilder<List<Komentar>>(
            future: _futureKomentar,
            builder: (context, snapshot) {
              // LOADING KOMENTAR
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // GALAT KOMENTAR
              if (snapshot.hasError) {
                return SizedBox(
                  height: 250,
                  child: GalatWidget(
                    pesan: '${snapshot.error}',
                    onCobaLagi: _cobaLagi,
                  ),
                );
              }

              // KOMENTAR KOSONG
              final komentar = snapshot.data ?? [];

              if (komentar.isEmpty) {
                return const Text('Belum ada komentar');
              }

              // DAFTAR KOMENTAR
              return Column(
                children: komentar.map((item) {
                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.email,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const Divider(height: 20),
                          Text(item.body),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
