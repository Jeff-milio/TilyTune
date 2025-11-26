import 'package:flutter/material.dart';

import '../AlbumPage/albumpage.dart';
import '../data.dart';

class PlaylistsTab extends StatelessWidget {
  final double cardWidth = 160;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(12).copyWith(bottom: 100),
      children: playlistsData.entries.map((entry) {
        String category = entry.key;
        List<Map<String, dynamic>> playlists = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Momotrust'
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: playlists.length,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final Map<String, dynamic> playlist = playlists[index];

                  // Conversion des tracks en List<Map<String, String>>
                  final List<Map<String, String>> tracks = (playlist['tracks'] as List)
                      .map((track) => Map<String, String>.from(track))
                      .toList();

                  final firstCover = tracks.isNotEmpty
                      ? tracks[0]['cover'] ?? 'assets/images/placeholder.jpg'
                      : 'assets/images/placeholder.jpg';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AlbumPage(
                                    title: playlist["title"] ?? 'Titre inconnu',
                                    artist: playlist["artist"] ?? 'Artiste inconnu',
                                    tracks: tracks,
                                    album: {},
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: cardWidth,
                              height: cardWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(firstCover),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Dégradé bas
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(8.0)),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xA6000000),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Bouton download
                          Positioned(
                            bottom: 3,
                            right: 5,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Color(0xFF295A65),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.file_download_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  print('Téléchargement de ${playlist["title"]}');
                                },
                                padding: const EdgeInsets.all(1),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),



                          // Icône bibliothèque
                          Positioned(
                            bottom: -2,
                            left: -4,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.video_library_outlined,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AlbumPage(
                                        title: playlist["title"] ?? 'Titre inconnu',
                                        artist: playlist["artist"] ?? 'Artiste inconnu',
                                        tracks: tracks,
                                        album: {},
                                      ),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: cardWidth,
                        child: Text(
                          playlist["title"] ?? 'Titre inconnu',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 2),
                      SizedBox(
                        width: cardWidth,
                        child: Text(
                          playlist["artist"] ?? 'Artiste inconnu',
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }
}
