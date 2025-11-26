import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../musiquePlayerPage/musiqueplayerPage.dart';

class AlbumPage extends StatelessWidget {

  final String title;
  final String artist;
  final List<Map<String, String>> tracks;

  const AlbumPage({
    super.key,
    required this.title,
    required this.artist,
    required this.tracks, required Map<String, String> album,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ,style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),

      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tracks.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    tracks[0]['cover'] ?? 'assets/images/placeholder.jpg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              artist,
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            const Text(
              'Liste des morceaux :',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];

                  return ListTile(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: MusicPlayerPage(track: track, tracks: []),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      );
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        track['cover'] ?? 'assets/images/placeholder.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      track['title'] ?? 'Titre inconnu',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      track['artist'] ?? 'Artiste inconnu',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.file_download_outlined,
                          color: Colors.white),
                      onPressed: () {
                        print('Téléchargement de ${track['title']}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
