import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // NOUVEL IMPORT SUPABASE
import 'package:tilytune1/CRUD/Crud_Users/signup_page.dart';
import '../CRUD/Crud_Users/loginpage.dart';

// ------------------------------------
// 1. La page d'accueil des paramètres
// ------------------------------------

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreScreenState();
}

class _ParametreScreenState extends State<Parametre> {
  // Simule l'état de la langue (true = Malagasy, false = Français)
  bool isMalagasy = false;

  // Définition de la couleur de fond sombre pour le corps
  final Color darkBackground = const Color(0xFF120202);

  // Style de titre pour les sections
  final TextStyle sectionHeaderStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // --- Fonctions d'action ---

  void _changeLanguage(BuildContext context) {
    // ... (Code inchangé pour changer de langue)
    setState(() {
      isMalagasy = !isMalagasy;
    });

    String message = isMalagasy
        ? "Langue changée en Malagasy (Simulé)"
        : "Langue changée en Français (Simulé)";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor:const Color(0xFF454545),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _inviteFriends(BuildContext context) {
    // ... (Code inchangé pour Inviter des amis)
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: darkBackground,
          title: const Text("Inviter des amis", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Ceci simule l'ouverture de la feuille de partage système pour envoyer le lien de l'application.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // 3. Déconnexion (UTILISE MAINTENANT SUPABASE)
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: darkBackground,
          title: const Text("Déconnexion", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Êtes-vous sûr de vouloir vous déconnecter ?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Ferme la boîte de dialogue

                // --- ACTION SUPABASE : DÉCONNEXION ---
                try {
                  await Supabase.instance.client.auth.signOut();
                  print("ACTION: Utilisateur déconnecté de Supabase. Redirection vers LoginPage.");

                  // Redirection vers la page de connexion, effaçant l'historique de navigation
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false, // Efface toutes les routes
                    );
                  }
                } catch (e) {
                  print("Erreur lors de la déconnexion: $e");
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Échec de la déconnexion. Veuillez réessayer.", style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Déconnexion', style: TextStyle(color: Color(0xFFFFE3BB))),
            ),
          ],
        );
      },
    );
  }

  // 4. Suppression du compte (UTILISE MAINTENANT SUPABASE)
  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: darkBackground,
          title: const Text("Supprimer le compte", style: TextStyle(color: Color(
              0xFF851313), fontWeight: FontWeight.bold)),
          content: const Text(
            "ATTENTION: Cette action est irréversible. Voulez-vous vraiment supprimer votre compte ? Toutes les données seront perdues.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Ferme la boîte de dialogue

                // --- ACTION SUPABASE : SUPPRESSION DE L'UTILISATEUR ET DÉCONNEXION ---
                try {
                  // NOTE TRÈS IMPORTANTE:
                  // La suppression d'un utilisateur depuis le client nécessite souvent des politiques RLS
                  // très spécifiques (et risquées) ou l'utilisation d'une Function Edge.
                  // Dans le cas d'une application client-only Flutter, la solution
                  // la plus courante et sécurisée est de DÉCONNECTER l'utilisateur après
                  // avoir DÉCLENCHÉ la suppression de son profil.

                  // 1. SUPPRIMER LES DONNÉES DU PROFIL (si vous n'avez pas de RLS en CASCADE DELETE)
                  // On suppose que la suppression du profil est autorisée par RLS pour l'utilisateur actuel.
                  final userId = Supabase.instance.client.auth.currentUser?.id;

                  if (userId != null) {
                    await Supabase.instance.client
                        .from('profiles')
                        .delete()
                        .eq('id', userId);
                    print("ACTION: Profil utilisateur supprimé dans 'profiles'.");

                    // 2. Supprimer l'utilisateur de l'authentification (Cette action est plus complexe côté client)
                    // Supabase ne fournit pas de méthode simple côté client pour qu'un utilisateur
                    // se supprime lui-même du système Auth pour des raisons de sécurité.
                    // Pour un projet réel, vous devriez utiliser une Function Edge ou une
                    // base de données trigger qui supprime l'utilisateur Auth après
                    // la suppression de son profil.
                    //
                    // Pour la SIMULATION côté client, nous allons seulement déconnecter
                    // et rediriger, en comptant sur la Function Edge/Trigger pour le nettoyage final.
                  }


                  await Supabase.instance.client.auth.signOut(); // Déconnexion
                  print("ACTION: Utilisateur déconnecté. Redirection vers SignupPage.");

                  // Redirection vers la page d'inscription, effaçant l'historique
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                          (route) => false,
                    );
                  }
                } on PostgrestException catch (e) {
                  print("Erreur Postgrest lors de la suppression du profil: $e");
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Échec de la suppression du profil (RLS?).", style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                } catch (e) {
                  print("Erreur lors de la suppression du compte: $e");
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Échec de la suppression du compte. Vérifiez les RLS.", style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (Reste de la méthode build inchangé)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0101),
        title: const Text(
          "Paramètre",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: darkBackground,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          children: <Widget>[
            // --- Section Général ---
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 10.0),
              child: Text("PRÉFÉRENCES", style: sectionHeaderStyle),
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: "Langue",
              trailing: Text(
                isMalagasy ? "Malagasy" : "Français",
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
              ),
              onTap: () => _changeLanguage(context),
            ),
            _buildSettingsTile(
              icon: Icons.share,
              title: "Inviter des amis",
              onTap: () => _inviteFriends(context),
            ),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: "À propos",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AproposPage()),
                );
              },
            ),

            // --- Section Compte ---
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 30.0),
              child: Text("COMPTE", style: sectionHeaderStyle),
            ),
            _buildSettingsTile(
              icon: Icons.logout,
              title: "Déconnexion",
              color: const Color(0xFFFFE3BB)
              ,
              onTap: () => _logout(context),
            ),
            _buildSettingsTile(
              icon: Icons.delete_forever,
              title: "Supprimer le compte",
              color: Colors.redAccent,
              onTap: () => _deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color? color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      tileColor: darkBackground,
    );
  }
}

// ------------------------------------
// 2. La page "À propos" (AproposPage)
// ------------------------------------
// (Code inchangé)

class AproposPage extends StatelessWidget {
  const AproposPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBackground = Color(0xFF120202);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B0101),
          title: const Text(
            "À propos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: darkBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Remplacement de Image.asset par un placeholder si l'asset n'est pas disponible
              const Center(child: Icon(Icons.music_note, color: Colors.white, size: 40)),
              const SizedBox(height: 10),

              const Center(
                child: Text(
                  "Version Beta (Build 20241020)",
                  style: TextStyle(fontSize: 14, color: Colors.white54 ),
                ),),
              const Divider(height: 40, color: Colors.white12),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Application de streaming musicale scout.....",
                style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 30),
              const Text(
                "Mentions Légales",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "© 2025 MonEntreprise. Tous droits réservés.\n"
                    "Conditions d'utilisation et Politique de confidentialité "
                    "disponibles sur notre site web (Atoo eeeeeee)."
                    ""
                    "Mampiasa finaritra eeeeeeh",
                style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
              ),],
          ),
        )
    );
  }
}