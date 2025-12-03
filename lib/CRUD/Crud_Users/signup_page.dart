import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'abonementpage.dart';
import 'loginpage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs (simplifiés)
  final nomOuTotemCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  // Focus Nodes
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    nomOuTotemCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  // --- LOGIQUE D'INSCRIPTION SUPABASE ---
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final email = emailCtrl.text.trim();
      final password = passCtrl.text.trim();
      final totem = nomOuTotemCtrl.text.trim();

      // 1. Inscription dans Supabase Auth (email + mot de passe)
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      // 2. Enregistrement du Totem dans la table 'profiles'
      if (res.user != null) {
        await supabase.from('profiles').insert({
          'id': res.user!.id,
          'email': email,
          'totem': totem, // Assurez-vous que cette colonne existe dans Supabase
        });

        if (mounted) {
          // 3. Navigation vers la page d'abonnement
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SubscriptionPage()),
          );
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur inattendue: $e"), backgroundColor: Colors.red),
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/1763641957934.png"), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF60000E),
                  Color(0xFF1C0303),
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
                      // Logo et titres...
                      Image.asset("assets/images/logo2_tilytune.png", width: 160,),
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
                            // 1. NOM / TOTEM
                            _buildCustomField(
                              controller: nomOuTotemCtrl,
                              label: "Nom d'utilisateur ou Totem",
                              icon: Icons.person,
                              hasNext: true,
                              nextFocus: _emailFocus,
                            ),
                            const SizedBox(height: 20),

                            // 2. EMAIL
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

                            // 3. MOT DE PASSE
                            _buildPasswordField(),
                            const SizedBox(height: 20),

                            // 4. CONFIRMATION MOT DE PASSE
                            _buildConfirmPasswordField(),

                            const SizedBox(height: 40),

                            // BOUTON S'INSCRIRE
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB88E5C),
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  shadowColor: const Color(0xFFDC3D3D).withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: _isLoading ? null : _signUp,
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                  "S'INSCRIRE",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Déjà membre ?", style: TextStyle(color: Colors.white70 , fontSize: 15)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage())
                              );
                            },
                            child: const Text(
                              "Se connecter",
                              style: TextStyle(
                                  color: Color(0xFFD3BC95),
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
      style: const TextStyle(color: Colors.white),
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
        fillColor: Colors.white.withOpacity(0.1),
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
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPassFocus),
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

  // Widget pour la confirmation du mot de passe
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPassCtrl,
      focusNode: _confirmPassFocus,
      obscureText: !_isConfirmPasswordVisible,
      style: const TextStyle(color: Colors.white),
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) return "Confirmation requise";
        // Validation que les deux mots de passe correspondent
        if (value != passCtrl.text) return "Les mots de passe ne correspondent pas";
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirmer le mot de passe",
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.lock_reset, color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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