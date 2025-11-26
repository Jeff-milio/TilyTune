import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tilytune1/acceuil/recommandepage/recommandepage.dart';
import '../AlbumPage/albumpage.dart';
import '../data.dart';
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
  void moveTrackToTop(Map<String, String> track) {
    setState(() {
      recentTracks.remove(track); // Supprime de sa position actuelle
      recentTracks.insert(0, track); // Ajoute à la première position
    });
  }

  final items = [
    Image.asset('assets/images/charte.g_1.jpg'),
    Image.asset('assets/images/odd.tilytune.jpg'),
  ];
  int CurentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A0F12),
                Color(0xFF501C1F),
                Color(0xF4000000)],
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => recherche()),
              );
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.flame, color: Colors.white70),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => free()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white70),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => profil()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF150303),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CAROUSEL
              Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
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
                    items: items
                        .asMap()
                        .entries
                        .map((entry) {
                      Widget item = entry.value;
                      return Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 8,
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
                      effect: WormEffect(
                        dotHeight: 7,
                        dotWidth: 8,
                        dotColor: Colors.white70,
                        activeDotColor: Color(0xFFE8C8A2),
                        spacing: 9,
                        paintStyle: PaintingStyle.fill,
                      ),
                    ),
                  ),
                ],
              ),

              // RECOMMANDÉ POUR VOUS
              _buildSectionHeader(
                'Recommandé pour vous',
                onVoirTout: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => recommandePage(albums: albums),
                    ),
                  );
                },
              ),
              _buildFeaturedAlbumList(albums.sublist(1, 3)),
              // NOUVEAUTÉS
              _buildSectionHeader(
                'Nouveautés',
                onVoirTout: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => nouveaute(albums: albums),
                    ),
                  );
                },
              ),
              _buildHorizontalAlbumList(albums),

              // VOS PLAYLISTS RECEMMENT ÉCOUTÉES -> LISTE DE MUSIQUES
              _buildSectionHeader('Musiques Récemment Écoutées'),
              // pas de bouton
              _buildRecentTracksScrollable(recentTracks),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onVoirTout}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Momotrust',
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onVoirTout != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                onPressed: onVoirTout,
                child: const Text(
                  'Voir tout',
                  style: TextStyle(color: Color(0xFFE8C8A2)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- Album Horizontal List (standard) ---
  Widget _buildHorizontalAlbumList(List<Map<String, String>> list) {
    return SizedBox(
      height: 240.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final album = list[index];
          return _AlbumCard(
            title: album['title']!,
            artist: album['artist']!,
            coverPath: album['cover'] ?? '',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>
                    AlbumPage(
                      album: album, title: '', artist: '', tracks: [],)),
              );
            },
            onDownload: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Téléchargement de ${album['title']} en cours...',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- Featured Album List ---
  Widget _buildFeaturedAlbumList(List<Map<String, String>> list) {
    return SizedBox(
      height: 280.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final album = list[index];
          return _FeaturedAlbumCard(
            title: album['title']!,
            artist: album['artist']!,
            coverPath: album['cover'] ?? '',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>
                    AlbumPage(
                      album: album, title: '', artist: '', tracks: [],)),
              );
            },
            onDownload: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Téléchargement de ${album['title']} en cours...',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentTracksScrollable(List<Map<String, String>> list) {
    return Container(
      height: 300,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        shrinkWrap: false,
        physics: BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final track = list[index];

          return StatefulBuilder(
            builder: (context, setState) {
              bool isPressed = false;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => setState(() => isPressed = true),
                onTapCancel: () => setState(() => isPressed = false),
                onTapUp: (_) {
                  setState(() => isPressed = false);

                  moveTrackToTop(track);
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: MusicPlayerPage(track: track, tracks: [],),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                },
                child: AnimatedScale(
                  duration: Duration(milliseconds: 120),
                  scale: isPressed ? 0.95 : 1.0, // 🔥 Animation de clic
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            track['cover']!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track['title']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                track['artist']!,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(
                          Icons.file_download_outlined,
                          color: Colors.white,
                          size: 27,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// --- WIDGETS ALBUM CARDS (inchangés) ---
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
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(width: coverSize, height: coverSize);
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  // hauteur du dégradé
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(8.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xA6000000), // couleur sombre
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 5,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Color(0xFF295A65),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.file_download_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: onDownload,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
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
                        size: 35,
                      ),
                      onPressed: () {
                        // Ouvre la page de l'album
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AlbumPage(album: {
                              'title': title,
                              'artist': artist,
                              'cover': coverPath,
                            }, title: '', artist: '', tracks: [],),
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
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              artist,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
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
                  child: Image.asset(
                    coverPath,
                    width: coverSize,
                    height: coverSize,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  // hauteur du dégradé
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(8.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xA6000000), // couleur sombre
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 3,
                  right: 5,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF295A65),
                      shape: BoxShape.circle,
                    ),

                    child: IconButton(
                      icon: const Icon(
                        Icons.file_download_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: onDownload,
                      padding: const EdgeInsets.all(1),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 6,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: const Icon(
                        Icons.video_library_outlined,
                        color: Color(0xFFFFFFFF),
                        size: 47,
                      ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AlbumPage(album: {
                                'title': title,
                                'artist': artist,
                                'cover': coverPath,
                              }, title: '', artist: '', tracks: [],),
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
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              artist,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
