import 'package:flutter/material.dart';
import 'package:tilytune1/AlbumPage/albumpage.dart';

class Playlist {
  final String title;
  final String imageUrl;
  final List<String> songs;

  Playlist({
    required this.title,
    required this.imageUrl,
    required this.songs,
  });
}

class Monplaylist extends StatefulWidget {
  const Monplaylist({super.key});

  @override
  State<Monplaylist> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<Monplaylist> {
  // Couleur personnalisée : Rouge Bordeaux Sombre
  final List<Playlist> playlists = [
    Playlist(
      title: "Soirée Jazz & Vin",
      imageUrl: "https://picsum.photos/200/200?random=10",
      songs: ["Take Five", "So What", "My Favorite Things"],
    ),
    Playlist(
      title: "Rock Années 80",
      imageUrl: "https://picsum.photos/200/200?random=20",
      songs: ["Back in Black", "Sweet Child O' Mine", "Jump"],
    ),
    Playlist(
      title: "Workout Intense",
      imageUrl: "https://picsum.photos/200/200?random=30",
      songs: ["Lose Yourself", "Till I Collapse", "Numb"],
    ),
    Playlist(
      title: "Nuit Calme",
      imageUrl: "https://picsum.photos/200/200?random=40",
      songs: ["River Flows in You", "Clair de Lune"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. LE BACKGROUND ROUGE BORDEAUX SOMBRE
      backgroundColor: Color(0xFF1E0606),

      appBar: AppBar(
        title: const Text("Mes Playlists"),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Transparent pour voir le fond
        elevation: 0,
        // Texte en blanc pour le contraste
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // --- Zone "Ajouter un nouveau" AGRANDIE ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 80, // 2. Hauteur augmentée (C'était 50 avant)
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Création d'une nouvelle playlist...")),
                  );
                },
                icon: Icon(Icons.add_circle, size: 32, color:Color(0xFF1E0606)), // Icône plus grande
                label: Text(
                  "CRÉER UNE PLAYLIST", // En majuscule pour le style
                  style: TextStyle(
                    fontSize: 18, // Texte plus gros
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E0606),
                    letterSpacing: 1.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Fond blanc pour ressortir sur le rouge
                  elevation: 8, // Ombre plus marquée
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),

          // --- Liste des Playlists ---
          Expanded(
            child: ListView.builder(
              itemCount: playlists.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return _buildPlaylistCard(context, playlist);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistCard(BuildContext context, Playlist playlist) {
    String firstSong = playlist.songs.isNotEmpty ? playlist.songs[0] : "";
    String secondSong = playlist.songs.length > 1 ? playlist.songs[1] : "";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      color:Color(0xFF3E3E3E), // Carte blanche légèrement opaque
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlbumPage(title: '', artist: '', tracks: [], album: {},),
                // On passe la couleur pour la page suivante,
            ),
          );
        },
        child: SizedBox(
          height: 110, // Légèrement plus grand pour aérer
          child: Row(
            children: [
              // Image à gauche
              SizedBox(
                width: 110,
                height: 110,
                child: Image.network(
                  playlist.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey, child: const Icon(Icons.music_note)),
                ),
              ),

              // Contenu Texte
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        playlist.title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF), // Titre en bordeaux
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Titres
                      if (firstSong.isNotEmpty)
                        _buildSongRow(Icons.play_arrow_rounded, firstSong),
                      if (secondSong.isNotEmpty)
                        _buildSongRow(Icons.skip_next_rounded, secondSong),
                    ],
                  ),
                ),
              ),

              // Flèche
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1E0606).withOpacity(0.5)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Color(0xFFEFEFEF)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Color(0xFFBCBCBC)),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}

