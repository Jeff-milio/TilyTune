import 'package:flutter/material.dart';
import 'package:tilytune1/CRUD/Crud_Users/user_model.dart';
import 'abonementpage.dart';
import 'loginpage.dart';

// --- PAGE D'INSCRIPTION (SIGNUP) ---
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  final nomCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController(); // Nouveau contrôleur mot de passe

  // Focus Nodes pour la navigation automatique
  final _prenomFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Toujours disposer les contrôleurs et focus nodes
    nomCtrl.dispose();
    prenomCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    _prenomFocus.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Le Scaffold est transparent pour laisser voir le Container dégradé derrière si besoin,
      // ou on met le dégradé dans le body.
        body: Container(

          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage( "assets/images/1763641957934.png" ), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF60000E), // Rouge Bordeaux Sombre
                  Color(0xFF1C0303), // Vers le noir/rouge très profond
                  Colors.black,
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset( "assets/images/logo2_tilytune.png" , width: 160,),
                      const SizedBox(height: 10),
                      const Text(
                        "Créer un compte",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Momotrust",
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Rejoignez-nous dès maintenant",
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                      const SizedBox(height: 40),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // NOM
                            _buildCustomField(
                              controller: nomCtrl,
                              label: "Nom",
                              icon: Icons.person,
                              hasNext: true,
                              nextFocus: _prenomFocus,
                            ),
                            const SizedBox(height: 20),

                            // PRÉNOM
                            _buildCustomField(
                              controller: prenomCtrl,
                              label: "Prénom",
                              icon: Icons.person_outline,
                              focusNode: _prenomFocus,
                              hasNext: true,
                              nextFocus: _emailFocus,
                            ),
                            const SizedBox(height: 20),

                            // EMAIL
                            _buildCustomField(
                              controller: emailCtrl,
                              label: "Email",
                              icon: Icons.email_outlined,
                              inputType: TextInputType.emailAddress,
                              focusNode: _emailFocus,
                              hasNext: true,
                              nextFocus: _passFocus,
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Email requis";
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return "Email invalide";
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // MOT DE PASSE (NOUVEAU)
                            _buildPasswordField(),
                            const SizedBox(height: 40),

                            // BOUTON S'INSCRIRE
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB88E5C), // Rouge vif pour le bouton
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  shadowColor: const Color(0xFFDC3D3D).withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Création User + Navigation
                                    final user = UserModel(
                                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                                      nom: nomCtrl.text,
                                      prenom: prenomCtrl.text,
                                      email: emailCtrl.text,
                                    );

                                    // Simulation validation mot de passe
                                    print("Mot de passe: ${passCtrl.text}");

                                    // On va vers la page d'abonnement au lieu de Page1 directement
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const SubscriptionPage()),
                                    );
                                  }
                                },
                                child: const Text(
                                  "S'INSCRIRE",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Navigation vers Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Déjà membre ?", style: TextStyle(color: Colors.white70 , fontSize: 15)),
                          TextButton(
                            onPressed: () {
                              // Navigation vers la page de Login définie plus bas
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage())
                              );
                            },
                            child: const Text(
                              "Se connecter",
                              style: TextStyle(
                                  color: Color(0xFFD3BC95), // Rouge clair
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }

  // Widget réutilisable pour les champs de texte standards
  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    bool hasNext = false,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white), // Texte en blanc
      textInputAction: hasNext ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) return "Ce champ est requis";
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1), // Effet transparent
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.redAccent)
        ),
      ),
    );
  }

  // Widget spécifique pour le mot de passe
  Widget _buildPasswordField() {
    return TextFormField(
      controller: passCtrl,
      focusNode: _passFocus,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) return "Mot de passe requis";
        if (value.length < 6) return "Min. 6 caractères";
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mot de passe",
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.5),
        ),
      ),
    );
  }
}