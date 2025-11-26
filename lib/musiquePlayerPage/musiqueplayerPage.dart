import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:just_audio/just_audio.dart';

/// Singleton global pour éviter les crashes
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioPlayer player = AudioPlayer();

  // Ce Notifier permet au MiniPlayer de se mettre à jour instantanément
  static final ValueNotifier<Map<String, String>?> currentTrackNotifier = ValueNotifier(null);

  static void stopMusic() {
    player.stop();
    currentTrackNotifier.value = null; // Cache le MiniPlayer
  }
}


/// Page du lecteur de musique
class MusicPlayerPage extends StatefulWidget {
  final Map<String, String> track;
  final List<Map<String, String>> tracks;

  const MusicPlayerPage({super.key, required this.track, required this.tracks});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer _audioPlayer;

  bool _isFavorite = false;
  bool _isDownloaded = false;
  int _loopMode = 0; // 0: none, 1: all, 2: one

  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioService.player;
    _setupPlayer();
  }

// Dans _MusicPlayerPageState

// Dans _MusicPlayerPageState

// DANS MusicPlayerPage.dart

  Future<void> _setupPlayer() async {
    try {
      final oldTrack = AudioService.currentTrackNotifier.value;
      final newTrack = widget.track;

      // 1. Vérification : Est-ce exactement la même musique (Audio + Titre) ?
      bool isSameSong = (oldTrack != null &&
          oldTrack['audio'] == newTrack['audio']);

      if (isSameSong) {
        // Si c'est la même, on s'assure juste qu'elle joue
        if (!AudioService.player.playing) {
          AudioService.player.play();
        }
        // On met à jour l'affichage au cas où
        AudioService.currentTrackNotifier.value = newTrack;
        return;
      }

      // 2. C'est une NOUVELLE musique : On arrête tout et on recharge
      await AudioService.player.stop();

      // Mise à jour de l'UI (Le MiniPlayer changera ici)
      AudioService.currentTrackNotifier.value = newTrack;

      // Chargement et lecture
      await AudioService.player.setAsset(newTrack['audio']!.trim());
      AudioService.player.play();

    } catch (e) {
      debugPrint("Erreur audio : $e");
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFF2E2E33);
    const Color skipColor = Color(0xFFEEEEEE);

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        endDrawer: _buildEndDrawer(),
        body: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.black)),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF40171A), Color(0xFF230606), Colors.black, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(color: const Color(0xFF531010).withOpacity(0.2)),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildAlbumArt(cardColor),
                    const SizedBox(height: 30),
                    _buildTrackInfo(),
                    const SizedBox(height: 40),
                    _buildProgressSlider(Colors.white),
                    const SizedBox(height: 30),
                    _buildPlaybackControls(skipColor),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            _buildLyricsDraggableSheet(cardColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_outlined, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
    ),
  );

  Widget _buildEndDrawer() => Drawer(
    backgroundColor: const Color(0xFF2E2E33).withOpacity(0.95),
    child: ListView(
      padding: EdgeInsets.zero,
      children: const [
        DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF40171A)),
          child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          leading: Icon(Icons.info_outline, color: Colors.white),
          title: Text('À propos de TilyTune', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
  Widget _buildAlbumArt(Color cardColor) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cardColor.withOpacity(0.5),
        border: Border.all(color: Colors.white10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 25, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          widget.track['cover'] ?? 'assets/images/placeholder.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.music_note, color: Colors.white, size: 80)),
        ),
      ),
    );
  }

  Widget _buildTrackInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.track['title'] ?? 'Titre Inconnu',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(widget.track['artist'] ?? 'Artiste Inconnu', style: const TextStyle(color: Colors.white54, fontSize: 16)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.playlist_add, color: Colors.white70, size: 30),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ajouté à la playlist !"))),
        ),
        IconButton(
          icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? const Color(0xFFFFE7C2) : Colors.white70, size: 30),
          onPressed: () => setState(() => _isFavorite = !_isFavorite),
        ),
      ],
    );
  }

  Widget _buildProgressSlider(Color accentColor) {
    return StreamBuilder<Duration>(
      stream: _audioPlayer.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final total = _audioPlayer.duration ?? Duration.zero;

        return Column(
          children: [
            Slider(
              value: position.inSeconds.toDouble().clamp(0.0, total.inSeconds.toDouble()),
              min: 0,
              max: total.inSeconds.toDouble() > 0 ? total.inSeconds.toDouble() : 1,
              onChanged: (value) => setState(() => _isDragging = true),
              onChangeEnd: (value) {
                _isDragging = false;
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(position), style: const TextStyle(color: Colors.white54)),
                  Text(_formatDuration(total), style: const TextStyle(color: Colors.white54)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlaybackControls(Color skipColor) {
    return StreamBuilder<PlayerState>(
      stream: _audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final playing = state?.playing ?? false;
        final processing = state?.processingState ?? ProcessingState.idle;

        Widget mainButton;
        if (processing == ProcessingState.loading || processing == ProcessingState.buffering) {
          mainButton = const SizedBox(width: 70, height: 70);
        } else if (!playing) {
          mainButton = IconButton(icon: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 70), onPressed: _audioPlayer.play);
        } else if (processing != ProcessingState.completed) {
          mainButton = IconButton(icon: const Icon(Icons.pause_circle_rounded, color: Colors.white, size: 70), onPressed: _audioPlayer.pause);
        } else {
          mainButton = IconButton(icon: const Icon(Icons.replay_circle_filled_rounded, color: Colors.white, size: 70),
              onPressed: () => _audioPlayer.seek(Duration.zero).then((_) => _audioPlayer.play()));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(_isDownloaded ? Icons.download_done : Icons.file_download_outlined,
                  color: _isDownloaded ? const Color(0xFF338FA5) : Colors.white, size: 32),
              onPressed: () => setState(() => _isDownloaded = !_isDownloaded),
            ),
            IconButton(icon: Icon(Icons.skip_previous_rounded, color: skipColor, size: 45), onPressed: () {}),
            mainButton,
            IconButton(icon: Icon(Icons.skip_next_rounded, color: skipColor, size: 45), onPressed: () {}),
            IconButton(
              icon: Icon(_loopMode == 0 ? Icons.repeat : _loopMode == 1 ? Icons.repeat_one : Icons.shuffle,
                  color: _loopMode == 0 ? Colors.white54 : Colors.white, size: 28),
              onPressed: () => setState(() => _loopMode = (_loopMode + 1) % 3),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLyricsDraggableSheet(Color cardColor) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.85,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(color: cardColor.withOpacity(0.45), border: Border.all(color: Colors.white12)),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const Text('Paroles', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text(
                  "Les paroles ne sont pas encore disponibles pour ce morceau.\nElles arriveront bientôt !",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
