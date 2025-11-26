import 'dart:ui'; // Nécessaire pour l'effet de flou (Blur)
import 'package:flutter/material.dart';
import '../../Page principale/page 1.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});
  

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  // Sélection de l'offre
  bool _isPremiumSelected = false;

  // Contrôleurs
  final _paymentCtrl = TextEditingController();    // Numéro
  final _secretCodeCtrl = TextEditingController(); // Code Secret
  final _validationCodeCtrl = TextEditingController(); // Code Reçu (SMS)

  bool _isLoading = false;

  @override
  void dispose() {
    _paymentCtrl.dispose();
    _secretCodeCtrl.dispose();
    _validationCodeCtrl.dispose();
    super.dispose();
  }

  // --- ÉTAPE 1 : Lancer le paiement ---
  void _startPaymentProcess() async {
    if (_paymentCtrl.text.isEmpty || _secretCodeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir le numéro et le code secret")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulation attente réseau
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      // On ouvre la fenêtre de validation (Code SMS) avec fond flou
      _showValidationDialog();
    }
  }

  // --- ÉTAPE 2 : Afficher la carte de validation (Fond Flou) ---
  void _showValidationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Oblige à valider ou annuler
      builder: (ctx) {
        return Stack(
          children: [
            // L'effet de flou sur tout l'écran derrière
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            // La carte de validation
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A4A4A).withOpacity(0.25), // Fond sombre semi-transparent
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x73FFFFFF), width: 1),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "CONFIRMATION",
                        style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Un code a été envoyé par SMS.\nVeuillez l'entrer ci-dessous.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 17),
                      ),
                      const SizedBox(height: 20),

                      // Champ Code SMS
                      TextField(
                        controller: _validationCodeCtrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 5, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black45,
                          hintText: "- - - -",
                          hintStyle: TextStyle(color: Colors.white30),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFD1A769)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFD1A769)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Bouton Valider
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD1A769),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            if (_validationCodeCtrl.text.isNotEmpty) {
                              Navigator.pop(ctx); // Ferme la boite de validation
                              _showSuccessAnimation(); // Lance le succès
                            }
                          },
                          child: const Text("VALIDER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Annuler", style: TextStyle(color: Colors.white54)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- ÉTAPE 3 : Animation de Succès puis Navigation ---
  void _showSuccessAnimation() async {
    // Affiche le dialogue de succès
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cercle animé ou Icone
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.greenAccent, width: 3),
                ),
                child: const Icon(Icons.check, color: Colors.greenAccent, size: 60),
              ),
              const SizedBox(height: 20),
              const Text(
                "Paiement Réussi !",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );

    // Attendre 2 secondes pour que l'utilisateur voie l'animation
    await Future.delayed(const Duration(seconds: 2));

    // Navigation vers Page1
    if (mounted) {
      // On ferme le dialog de succès d'abord (optionnel si on fait un pushReplacement total,
      // mais plus propre de fermer les dialogs ouverts)
      Navigator.of(context, rootNavigator: true).pop();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Page1()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF58000C), // Rouge Bordeaux Sombre
              Color(0xFF2B0505),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Choisissez votre\nExpérience",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Momotrust",
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Profitez de la meilleure musique sans limites.",
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // --- OFFRE GRATUITE ---
                _buildFreeCard(),

                const SizedBox(height: 20),

                // --- OFFRE PREMIUM ---
                _buildPremiumCard(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFreeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Standard", style: TextStyle(color: Color(0xFFFFD797), fontSize: 25, fontWeight: FontWeight.bold)),
                Text("Accès limité avec pubs", style: TextStyle(color: Colors.white70, fontSize: 15)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Page1()),
                    (route) => false,
              );
            },
            child: const Text("Continuer", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildPremiumCard() {
    return GestureDetector(
      onTap: () {
        // Toggle (Ouvrir / Fermer)
        setState(() {
          _isPremiumSelected = !_isPremiumSelected;
          if (!_isPremiumSelected) {
            _paymentCtrl.clear();
            _secretCodeCtrl.clear();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: _isPremiumSelected
              ? const Color(0xFFFFFFFF).withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isPremiumSelected ? const Color(0xFFFFD797) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text("PREMIUM", style: TextStyle(color: Color(0xFF45C3DC), fontWeight: FontWeight.bold,fontSize: 16, letterSpacing: 2)),
                        SizedBox(width: 5),
                        Icon(Icons.star, color: Color(0xFF46C0DC), size: 18),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text("3 000 Ar", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const Text("/ mois", style: TextStyle(color: Color(0xFFFFFFFF))),
                  ],
                ),
                Container(
                  height: 24, width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _isPremiumSelected ? const Color(0xFF3D8D9F) : Colors.white24, width: 2),
                    color: _isPremiumSelected ? const Color(0xFF3D8D9F) : Colors.transparent,
                  ),
                  child: _isPremiumSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildFeatureRow("Qualité audio HD"),
            _buildFeatureRow("Mode hors ligne"),

            // FORMULAIRE DE PAIEMENT
            if (_isPremiumSelected) ...[
              const Divider(color: Colors.white24, height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Paiement Mobile", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ),
              const SizedBox(height: 15),

              // 1. Numéro
              TextFormField(
                controller: _paymentCtrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Numéro (034...)",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  prefixIcon: const Icon(Icons.phone_android, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 2. Code Secret Orange Money
              TextFormField(
                controller: _secretCodeCtrl,
                keyboardType: TextInputType.number,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Code Secret",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BOUTON PAYER (Ouvre la validation floutée)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1A769),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _isLoading ? null : _startPaymentProcess,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("PAYER 3 000 Ar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white54, size: 18),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}