import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../AlbumPage/albumpage.dart';
import '../data.dart'; // Assurez-vous que RecentTracksManager est bien ici
import '../free/free.dart';
import '../musiquePlayerPage/musiqueplayerPage.dart';
import '../profil/profil.dart';
import '../recherche/recherche.dart';
import 'nouveaute/nouveaute.dart';

class acceuil extends StatefulWidget {
  const acceuil({super.key});

  @override
  _acceuilState createState() => _acceuilState();
}

class _acceuilState extends State<acceuil> {

  // NOTE: J'ai supprimé 'moveTrackToTop' ici car c'est maintenant géré
  // automatiquement par RecentTracksManager et MusicPlayerPage.

  final items = [
    Image.asset('assets/images/charte.g_1.jpg'),
    Image.asset('assets/images/odd.tilytune.jpg'),
  ];
  int CurentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> newsList = nouveautesData['Nouveautés']!;
    List<Map<String, dynamic>> featuredList = [];

    // Prend les 2 premiers éléments
    featuredList.addAll(
        newsList.sublist(0, newsList.length > 2 ? 2 : newsList.length));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A0F12), Color(0xFF501C1F), Color(0xF4000000)],
              begin: Alignment.bottomCenter,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset('assets/images/logo2_tilytune.png', height: 30),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined, color: Colors.white70),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => recherche())),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.flame, color: Colors.white70),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => free())),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white70),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => profil())),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF150303),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- CAROUSEL ---
              Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayInterval: const Duration(seconds: 4),
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          CurentIndex = index;
                        });
                      },
                    ),
                    items: items.map((item) {
                      return Stack(
                        children: [
                          Positioned(
                            left: 0, right: 0, top: 8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: item,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: AnimatedSmoothIndicator(
                      activeIndex: CurentIndex,
                      count: items.length,
                      effect: const WormEffect(
                        dotHeight: 7, dotWidth: 8,
                        dotColor: Colors.white70,
                        activeDotColor: Color(0xFFE8C8A2),
                        spacing: 9,
                        paintStyle: PaintingStyle.fill,
                      ),
                    ),
                  ),
                ],
              ),

              // --- RECOMMANDÉ ---
              _buildSectionHeader('Recommandé pour vous'),
              _buildFeaturedAlbumList(featuredList),

              // --- NOUVEAUTÉS ---
              _buildSectionHeader(
                'Nouveautés',
                onVoirTout: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => nouveaute(albums: albums)));
                },
              ),
              _buildHorizontalAlbumList(newsList),

              // --- RÉCEMMENT ÉCOUTÉES ---
              _buildSectionHeader('Musiques Récemment Écoutées'),
              // On n'a plus besoin de passer de liste en paramètre, il utilise le Manager interne
              _buildRecentTracksScrollable(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onVoirTout}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Momotrust', fontWeight: FontWeight.bold),
          ),
          if (onVoirTout != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                onPressed: onVoirTout,
                child: const Text('Voir tout', style: TextStyle(color: Color(0xFFE8C8A2))),
              ),
            ),
        ],
      ),
    );
  }

  // --- WIDGET LISTE HORIZONTALE (ALBUMS) ---
  Widget _buildHorizontalAlbumList(List<Map<String, dynamic>> list) {
    return SizedBox(
      height: 240.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final album = list[index];
          List<Map<String, String>> tracks = [];

          if (album['tracks'] != null) {
            try {
              tracks = (album['tracks'] as List).map((item) {
                return Map<String, String>.from(item as Map);
              }).toList();
            } catch (e) {
              print("Erreur de lecture des pistes : $e");
            }
          }

          String coverPath = album['cover'] ?? '';
          if (coverPath.isEmpty && tracks.isNotEmpty) {
            coverPath = tracks[0]['cover'] ?? '';
          }

          return _AlbumCard(
            title: album['title'] ?? 'Inconnu',
            artist: album['artist'] ?? 'Inconnu',
            coverPath: coverPath,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>
                    AlbumPage(
                      title: album['title'] ?? 'Titre',
                      artist: album['artist'] ?? 'Artiste',
                      tracks: tracks,
                      album: {
                        'title': album['title'] ?? '',
                        'artist': album['artist'] ?? '',
                        'cover': coverPath,
                      },
                    )
                ),
              );
            },
            onDownload: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Téléchargement de ${album['title']} en cours...')),
              );
            },
          );
        },
      ),
    );
  }

  // --- WIDGET FEATURED ---
  Widget _buildFeaturedAlbumList(List<Map<String, dynamic>> list) {
    return SizedBox(
      height: 280.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final album = list[index];
          List<Map<String, String>> tracks = [];
          if (album['tracks'] != null) {
            try {
              tracks = (album['tracks'] as List)
                  .map((item) => Map<String, String>.from(item as Map))
                  .toList();
            } catch (e) {
              print("Erreur pistes Featured : $e");
            }
          }

          String coverPath = album['cover'] ?? '';
          if (coverPath.isEmpty && tracks.isNotEmpty) {
            coverPath = tracks[0]['cover'] ?? '';
          }

          return _FeaturedAlbumCard(
            title: album['title'] ?? 'Inconnu',
            artist: album['artist'] ?? 'Inconnu',
            coverPath: coverPath,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>
                    AlbumPage(
                      title: album['title'] ?? 'Titre',
                      artist: album['artist'] ?? 'Artiste',
                      tracks: tracks,
                      album: {
                        'title': album['title'] ?? '',
                        'artist': album['artist'] ?? '',
                        'cover': coverPath,
                      },
                    ),
                ),
              );
            },
            onDownload: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Téléchargement de ${album['title']} en cours...')),
              );
            },
          );
        },
      ),
    );
  }

  // --- WIDGET RECENT TRACKS (CORRIGÉ & DYNAMIQUE) ---
  Widget _buildRecentTracksScrollable() {
    return Container(
      height: 300,
      // Ici on écoute les changements en temps réel
      child: ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: RecentTracksManager.tracksNotifier,
        builder: (context, tracks, child) {

          if (tracks.isEmpty) {
            return const Center(child: Text("Aucune écoute récente", style: TextStyle(color: Colors.white54)));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            shrinkWrap: false,
            physics: const BouncingScrollPhysics(),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return StatefulBuilder(
                builder: (context, setState) {
                  bool isPressed = false;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (_) => setState(() => isPressed = true),
                    onTapCancel: () => setState(() => isPressed = false),
                    onTapUp: (_) {
                      setState(() => isPressed = false);

                      // Pas besoin d'appeler moveTrackToTop manuellement ici.
                      // MusicPlayerPage le fera via son initState/_setupPlayer.

                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: MusicPlayerPage(track: track, tracks: tracks), // On passe la liste complète
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      );
                    },
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 120),
                      scale: isPressed ? 0.95 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                track['cover'] ?? 'assets/images/placeholder.jpg',
                                width: 50, height: 50, fit: BoxFit.cover,
                                errorBuilder: (c,e,s) => Container(color: Colors.grey, width: 50, height: 50),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(track['title'] ?? 'Titre', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text(track['artist'] ?? 'Artiste', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.play_circle_outline, color: Colors.white, size: 27),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// --- LES WIDGETS CARDS RESTENT INCHANGÉS ---

class _AlbumCard extends StatelessWidget {
  final String title;
  final String artist;
  final String coverPath;
  final VoidCallback onTap;
  final VoidCallback onDownload;
  final double cardWidth = 150;
  final double coverSize = 150;

  const _AlbumCard({
    required this.title,
    required this.artist,
    required this.coverPath,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    coverPath,
                    width: coverSize,
                    height: coverSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => SizedBox(width: coverSize, height: coverSize, child: Container(color: Colors.grey[800], child: const Icon(Icons.music_note, color: Colors.white))),
                  ),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0, height: 60,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xA6000000)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2, right: 5,
                  child: Container(
                    height: 35, width: 35,
                    decoration: const BoxDecoration(color: Color(0xFF295A65), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.file_download_outlined, color: Colors.white, size: 25),
                      onPressed: onDownload,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2, left: -4,
                  child: SizedBox(
                    width: 50, height: 50,
                    child: IconButton(
                      icon: const Icon(Icons.video_library_outlined, color: Colors.white, size: 35),
                      onPressed: onTap,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
            Text(artist, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _FeaturedAlbumCard extends StatelessWidget {
  final String title;
  final String artist;
  final String coverPath;
  final VoidCallback onTap;
  final VoidCallback onDownload;
  final double cardWidth = 220;
  final double coverSize = 220;

  const _FeaturedAlbumCard({
    required this.title,
    required this.artist,
    required this.coverPath,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(coverPath, width: coverSize, height: coverSize, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0, height: 60,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xA6000000)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 3, right: 5,
                  child: Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(color: Color(0xFF295A65), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.file_download_outlined, color: Colors.white, size: 30),
                      onPressed: onDownload,
                      padding: const EdgeInsets.all(1),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15, left: 6,
                  child: SizedBox(
                    width: 40, height: 40,
                    child: IconButton(
                      icon: const Icon(Icons.video_library_outlined, color: Color(0xFFFFFFFF), size: 47),
                      onPressed: onTap,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis, maxLines: 1),
            Text(artist, style: const TextStyle(color: Colors.white70, fontSize: 14), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}