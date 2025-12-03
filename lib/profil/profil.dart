import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'modifierprofil.dart';

class profil extends StatefulWidget {
  const profil({super.key});

  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> {
  // Controllers de profil
  String _totem = 'Chargement...';
  String _email = 'Chargement...';
  bool _isLoading = true;

  // Image locale
  XFile? _image;

  // Couleur de marque
  final Color _brandColor = const Color(0xFF6A131D);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Charger les données du profil depuis Supabase
  Future<void> _loadProfile() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('Utilisateur non connecté');

      final response = await Supabase.instance.client
          .from('profiles')
          .select('totem, email')
          .eq('id', userId)
          .single();

      if (!mounted) return;
      setState(() {
        _totem = response['totem'] ?? 'Nom inconnu';
        _email = response['email'] ?? 'Email inconnu';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _totem = 'Erreur';
        _email = 'Erreur lors du chargement';
        _isLoading = false;
      });
    }
  }

  // Sélection d’une image depuis la galerie
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120202),
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 📌 PHOTO DE PROFIL
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(File(_image!.path))
                        : const AssetImage('assets/images/profil.jpg')
                    as ImageProvider,
                  ),

                  // 📌 Bouton pour changer la photo
                  Container(
                    decoration: BoxDecoration(
                      color: _brandColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 20),
                      onPressed: pickImage,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 📌 TOTEM (Nom utilisateur)
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              _totem,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // 📌 Email sous le nom
            Text(
              _isLoading ? '...' : _email,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 25),

            // 📌 Suivis / Abonnés (statique)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat("Suivis", "0"),
                Container(width: 1, height: 25, color: Colors.grey.shade800),
                _buildStat("Abonnés", "0"),
              ],
            ),

            const SizedBox(height: 30),

            // 📌 À propos
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15),
                border:
                Border.all(color: Colors.red.shade900.withOpacity(0.5)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "À propos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Passionné de musique, de danse et de création. "
                        "Toujours à la recherche de nouveaux sons et d’inspiration !",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 📌 Bouton Modifier le profil
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6A131D),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          onPressed: () async {
            // Vérification pour s'assurer qu'il y a un totem à passer
            if (_totem == 'Chargement...' || _totem == 'Erreur') return;

            // Naviguer vers la page d'édition en passant le totem actuel
            // 'await' est utilisé pour attendre le résultat de la navigation
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(currentTotem: _totem),
              ),
            );

            // Si la page d'édition retourne 'true' (signifiant que la modification a réussi),
            // on recharge le profil pour mettre à jour l'affichage
            if (result == true) {
              _loadProfile();
            }
          },
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text(
            "Modifier le profil",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
