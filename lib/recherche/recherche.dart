import 'package:flutter/material.dart';

class recherche extends StatefulWidget {
  const recherche({super.key});

  @override
  State<recherche> createState() => _rechercheState();
}

class _rechercheState extends State<recherche> {
  // Contrôleur pour gérer le texte saisi dans la barre de recherche
  final TextEditingController _searchController = TextEditingController();

  // Variable pour vérifier si le champ de recherche est vide ou non
  bool _isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    // Ajout d'un écouteur pour détecter les changements de texte en temps réel
    _searchController.addListener(() {
      setState(() {
        _isSearchEmpty = _searchController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    // Toujours disposer du contrôleur quand la page est fermée pour libérer la mémoire
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120202), // Fond sombre comme demandé
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0101),
        elevation: 0, // Supprime l'ombre pour un look plat
        title: const Text(
          "Recherche",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Barre de Recherche ---
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A), // Gris foncé pour la barre
                borderRadius: BorderRadius.circular(10), // Coins arrondis
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white), // Texte en blanc
                cursorColor: Colors.redAccent, // Couleur du curseur
                autofocus: true, // Ouvre le clavier automatiquement au chargement

                decoration: InputDecoration(
                  hintText: "Rechercher titres, artistes...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none, // Enlève la ligne de soulignement par défaut
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

                  // Icône de recherche à gauche (prefix)
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white70,
                  ),

                  // Croix de suppression à droite (suffix), visible seulement si texte présent
                  suffixIcon: !_isSearchEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: () {
                      _searchController.clear(); // Efface le texte
                      // Le listener mettra à jour l'état automatiquement
                    },
                  )
                      : null,
                ),
                // Action quand on appuie sur "Rechercher" sur le clavier
                onSubmitted: (value) {
                  print("Recherche lancée pour : $value");
                },
              ),
            ),

            const SizedBox(height: 20),

            // --- Contenu Principal ---
            Expanded(
              child: _isSearchEmpty
                  ? _buildIARecommendations() // Affiche les recommandations IA si vide
                  : _buildSearchResults(),    // Affiche les résultats si recherche active
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour les recommandations générées par IA (Style Grille de Cartes)
  Widget _buildIARecommendations() {
    final List<Map<String, String>> suggestions = [
      {"title": "Découverte Hebdo", "subtitle": "Basé sur vos goûts"},
      {"title": "Mix Énergie", "subtitle": "Pour le sport"},
      {"title": "Chill Vibes", "subtitle": "Similaire à Artiste X"},
      {"title": "Top Viral IA", "subtitle": "Tendances"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la section avec une petite icône "magique"
        const Padding(
          padding: EdgeInsets.only(bottom: 15.0, left: 5.0),
          child: Row(
            children: [
              Text(
                "Pour vous",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: "Momotrust"
                ),
              ),
            ],
          ),
        ),
        // Grille de cartes
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cartes par ligne
              crossAxisSpacing: 12, // Espace horizontal entre les cartes
              mainAxisSpacing: 12, // Espace vertical entre les cartes
              childAspectRatio: 0.85, // Ratio hauteur/largeur pour donner une forme rectangulaire
            ),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // Couleur de fond de la carte
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Partie Image (Haut de la carte)
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade900,
                              Colors.blue.shade900
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.graphic_eq,
                          color: Colors.white70,
                          size: 40,
                        ),
                      ),
                    ),

                    // Partie Texte (Bas de la carte)
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              suggestions[index]["title"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              suggestions[index]["subtitle"]!,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget pour les résultats de recherche (simulés)
  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: Container(
            width: 50,
            height: 50,
            color: Colors.grey[850],
            child: const Icon(Icons.album, color: Colors.white),
          ),
          title: Text(
            "Résultat ${_searchController.text} #$index",
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: const Text(
            "Artiste trouvé",
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
    );
  }
}