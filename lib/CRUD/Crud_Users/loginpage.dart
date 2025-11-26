import 'package:flutter/material.dart';
import '../../Page principale/page 1.dart'; // Assurez-vous que cette importation est correcte

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  // Fonction appelée par le bouton SE CONNECTER
  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      // Si les validations passent (email et mot de passe sont valides)

      // Ici, vous ajouteriez votre logique d'authentification réelle (Firebase, API, etc.)

      // Redirection vers Page1
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Page1()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF58000C),
              Color(0xFF2B0505),
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                        Icons.lock_person, size: 80, color: Colors.white70),
                    const SizedBox(height: 20),
                    const Text(
                      "Bon retour !",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Entrez vos identifiants pour continuer",
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                    const SizedBox(height: 50),

                    // Email Login
                    TextFormField(
                      // VALIDATEUR D'EMAIL EXISTANT
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Email requis";
                        // Vérification basique du format email (au moins un @ et un .)
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                          return "Email invalide";
                        return null;
                      },
                      controller: emailCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                            Icons.email_outlined, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Login (VALIDATEUR AJOUTÉ)
                    TextFormField(
                      // VALIDATEUR DE MOT DE PASSE AJOUTÉ
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mot de passe requis";
                        }
                        if (value.length < 6) {
                          return "Le mot de passe doit contenir au moins 6 caractères";
                        }
                        return null;
                      },
                      controller: passCtrl,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors
                            .white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons
                                .visibility_off,
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
                      ),
                    ),

                    // Mot de passe oublié
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                            "Mot de passe oublié ?", style: TextStyle(
                            color: Colors.white54)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bouton Login
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        // APPEL À LA FONCTION DE SOUMISSION AVEC VALIDATION
                        onPressed: _submitLogin,
                        child: const Text(
                          "SE CONNECTER",
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}