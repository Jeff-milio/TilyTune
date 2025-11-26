import 'package:flutter/material.dart';

class profil extends StatelessWidget {
  const profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   Color(0xFF120202 ),
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

            // Photo de profil + bouton modifier
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/profil.jpg'), // à remplacer par NetworkImage() ou FileImage()
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color:Color(0xFF6A131D),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: () {
                        // TODO : Action pour changer la photo
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Nigara Manoa",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),
            const Text(
              "@nigaramanoa",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 25),

            // Suivis / Abonnés
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat("Suivis", "0"),
                Container(width: 1, height: 25, color: Colors.grey.shade800),
                _buildStat("Abonnés", "0"),
              ],
            ),

            const SizedBox(height: 30),

            // A propos
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.red.shade900.withOpacity(0.5)),
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

            // Bouton modifier le profil
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6A131D),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {
                // TODO : action pour modifier le profil
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
