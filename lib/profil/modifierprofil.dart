import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final String currentTotem;

  // Le totem actuel est passé au constructeur pour pré-remplir le champ
  const EditProfilePage({super.key, required this.currentTotem});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _totemController;
  bool _isLoading = false;

  final Color _brandColor = const Color(0xFF6A131D);
  final Color _darkBackground = const Color(0xFF120202);

  @override
  void initState() {
    super.initState();
    // Initialise le contrôleur avec la valeur actuelle
    _totemController = TextEditingController(text: widget.currentTotem);
  }

  @override
  void dispose() {
    _totemController.dispose();
    super.dispose();
  }

  // Fonction de mise à jour du profil (Totem) dans Supabase
  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newTotem = _totemController.text.trim();
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        throw Exception("Erreur: Utilisateur non authentifié.");
      }
      if (newTotem.isEmpty) {
        throw Exception("Le nom (Totem) ne peut pas être vide.");
      }

      // 1. Définir les données à mettre à jour
      final updates = {
        'totem': newTotem,
        // Vous pouvez ajouter d'autres champs ici (ex: 'updated_at': DateTime.now().toIso8601String()),
      };

      // 2. Exécuter l'opération d'UPDATE dans la table 'profiles'
      await Supabase.instance.client
          .from('profiles')
          .update(updates)
          .eq('id', userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès!')),
        );
        // Retourne à la page de profil et déclenche un rafraîchissement
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        print("Erreur de mise à jour du profil : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de la mise à jour: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBackground,
      appBar: AppBar(
        title: const Text("Modifier le profil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nom / Totem",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _totemController,
              decoration: InputDecoration(
                hintText: 'Entrez votre nouveau Totem',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                fillColor: Colors.black45,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _brandColor, width: 2),
                ),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: _isLoading ? null : _updateProfile,
                child: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : const Text(
                  "Enregistrer les modifications",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}