import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// Assure-toi d'importer ton fichier où se trouve AudioService et MusicPlayerPage
import '../musiquePlayerPage/musiqueplayerPage.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    // Écoute les changements de piste (Titre, Artiste, etc.)
    return ValueListenableBuilder<Map<String, String>?>(
      valueListenable: AudioService.currentTrackNotifier,
      builder: (context, currentTrack, child) {
        // SI AUCUNE MUSIQUE N'EST SÉLECTIONNÉE OU SI FERMÉE : ON CACHE LE WIDGET
        if (currentTrack == null) {
          return const SizedBox.shrink();
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            // Marge pour le décoller du bas de l'écran
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: GestureDetector(
              onTap: () {
                // Ouvre la page complète avec les infos actuelles
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MusicPlayerPage(
                      track: currentTrack,
                      tracks: const [], // Tu peux passer ta liste de lecture ici si tu l'as
                    ),
                  ),
                );
              },
              child: Container(
                height: 70,
                // Hauteur légèrement augmentée pour l'artiste
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E33), // Couleur sombre style Spotify/Apple Music
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    // --- 1. COVER IMAGE ---
                    Hero(
                      tag: 'mini_player_cover', // Animation fluide vers la grande page
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          currentTrack['cover'] ?? 'assets/images/placeholder.jpg',
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                              width: 54, height: 54,
                              color: Colors.grey[800],
                              child: const Icon(Icons.music_note, color: Colors.white)
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // --- 2. TITRE ET ARTISTE ---
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentTrack['title'] ?? "Titre inconnu",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            currentTrack['artist'] ?? "Artiste inconnu",
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // --- 3. BOUTONS DE CONTRÔLE ---

                    // StreamBuilder pour l'état Play/Pause uniquement
                    StreamBuilder<PlayerState>(
                      stream: AudioService.player.playerStateStream,
                      builder: (context, snapshot) {
                        final playing = snapshot.data?.playing ?? false;
                        return IconButton(
                          icon: Icon(
                            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            if (playing) {
                              AudioService.player.pause();
                            } else {
                              AudioService.player.play();
                            }
                          },
                        );
                      },
                    ),

                    // BOUTON FERMER (X)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 24),
                      onPressed: () {
                        // Arrête la musique et supprime le MiniPlayer
                        AudioService.stopMusic();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}