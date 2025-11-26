import 'package:flutter/material.dart';

class nouveaute extends StatelessWidget {
  final List<Map<String, String>> albums;
  const nouveaute({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('nouveaute')),
      body: ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return ListTile(
            leading: Image.asset(album['cover']!),
            title: Text(album['title']!),
            subtitle: Text(album['artist']!),
          );
        },
      ),
    );
  }
}

