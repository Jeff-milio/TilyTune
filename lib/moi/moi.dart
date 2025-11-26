import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tilytune1/moi/Favoris.dart';

import '../data.dart';
import '../musiquePlayerPage/musiqueplayerPage.dart';
import 'Telechargement.dart';
import 'monplaylist/monplaylist.dart';

class Moi extends StatefulWidget {
  @override
  State<Moi> createState() => _MoiState();
}

class _MoiState extends State<Moi> {
  void moveTrackToTop(Map<String, String> track) {
    setState(() {
      recentTracks.remove(track); // Supprime de sa position actuelle
      recentTracks.insert(0, track); // Ajoute à la première position
    });
  }

  XFile? _image;

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                colors: [
                  Color(0xFF120505),
                  Color(0xFF351215),
                  Color(0xFF220C0F),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              // 1. Header avec Dégradé et Infos de Profil
              SliverAppBar(
                expandedHeight: 180.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF40171A),
                          Color(0xFF2A0F12), // Rouge Bordeaux
                          Color(0xFF000000),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ---- PHOTO + STYLO ----
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // PHOTO
                                GestureDetector(
                                  onTap: pickImage,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xB5FFFFFF),
                                    radius: 55,
                                    backgroundImage: _image != null
                                        ? FileImage(File(_image!.path))
                                        : null,
                                    child: _image == null
                                        ? const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Color(0xFF000000),
                                          )
                                        : null,
                                  ),
                                ),
                                // STYLO
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: pickImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF212121),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ---- NOM + USERNAME ----
                          const SizedBox(width: 15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Nigara Manoa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '@ManoaNigara',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Options de navigation (Téléchargements, Favoris) et le GRAND Bouton Playlist
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildtelechargement(
                          context,
                          Icons.file_download_outlined,
                          'Téléchargements',
                          () {},
                        ),

                        _buildfavoris(
                          context,
                          Icons.favorite_border,
                          'Mes Favoris',
                          () {},
                        ),
                        SizedBox(height: 5),
                        _buildGiantPlaylistButton(context),
                        SizedBox(height: 30),

                        _buildSectionHeader('Musiques Récemment Écoutées'),
                        // pas de bouton
                        _buildRecentTracksScrollable(recentTracks),
                        const SizedBox(height: 100),
                        // LE NOUVEAU GRAND BOUTON PLAYLIST
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGiantPlaylistButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers une autre page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Monplaylist()),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // coins arrondis
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          // flou glassmorphism
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // couleur semi-transparente
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 0.3,
                  child: Image.asset(
                    "assets/images/1763641957934.png",
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 2),
                Text(
                  'Mon Playlist',
                  style: TextStyle(
                    fontFamily: 'Momotrust',
                    color: Color(0xFFFFECCD),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
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
        ],
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

          return GestureDetector(
            behavior: HitTestBehavior.opaque, // 🔥 capture tout le row
            onTap: () {
              moveTrackToTop(track);
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: MusicPlayerPage(track: track, tracks: [],),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

                  // 🎵 TITRE + ARTISTE
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

                  // ⬇️ Icône téléchargement (ne bloque plus le clic)
                  Icon(Icons.file_download_outlined,
                      color: Colors.white, size: 27),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  // Widget pour les telechargement
  Widget _buildtelechargement(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Naviguer vers une autre page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Telechargement()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// option pour favoris
Widget _buildfavoris(
  BuildContext context,
  IconData icon,
  String title,
  VoidCallback onTap,
) {
  return Card(
    color: Colors.grey[900],
    margin: EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      onTap: () {
        // Naviguer vers une autre page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Favoris()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
          ],
        ),
      ),
    ),
  );
}
