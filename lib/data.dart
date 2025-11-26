// data.dart

//----------data playlist ity-------------
final Map<String, List<Map<String, dynamic>>> playlistsData = {
  "Hira Fankalazana": [
    {
      "title": "Hira Fankalazana Tily",
      "artist": "Tily",
      "tracks": <Map<String, String>>[
        {"title": "Hira 90 taona Sampana Mena", "artist": "Sampana Mena", "cover": "assets/images/hira_fankalazana/90taonaspmena.jpg","audio": "assets/musique/HIRAFAHA90TAONASAMPANAMENA(TEM)(M4A_128K).m4a"},
        {"title": "Hira 90 taona Sampana Mavo", "artist": "Sampana Mavo", "cover": "assets/images/hira_fankalazana/90taonaspmavo.jpg","audio": "assets/audio/hira90.mp3"},
        {"title": "Hira faneva 100taona Tily", "artist": "Tily", "cover": "assets/images/hira_fankalazana/100taonatily.jpg","audio": "assets/musique/Hirajobily100taonaTilyetoMadagasikara(M4A_128K).m4a"},
        {"title": "Hira ny Ampamoloana", "artist": "Menafify", "cover": "assets/images/hira_fankalazana/hiraampamoloana2023.jpg","audio": "assets/musique/Hira35taonaMenafify_Tanteraho_(M4A_128K).m4a"},
        {"title": "Hira ny Diniery", "artist": "Mena", "cover": "assets/images/hira_fankalazana/hiranydiniery2023.jpg","audio": "assets/musique/Hiran_nyDINIERY(TENDRO_SampanaMena)-TilyetoMadagasikara(M4A_128K).m4a"},
        {"title": "Hira ny Lomay", "artist": "Maitso", "cover": "assets/images/hira_fankalazana/hiranylomay2023.jpg","audio": "assets/musique/Hiran_nyLOMAY(SampanaMaitso)-TilyetoMadagasikara(M4A_128K).m4a"},
      ],

    },
    {
      "title": "Fankalazana Mpanazava",
      "artist": "Mpanazava",
      "tracks": <Map<String, String>>[
        {"title": "80taona Mpanazava", "artist": "Mpanazava", "cover": "assets/images/hira_fankalazana/80taonampanazava.jpg"},
        {"title": "75taona Afo", "artist": "Afo", "cover": "assets/images/hira_fankalazana/75taonaafo.jpg"},
      ],
    },
  ],
  "Hira Sapaoritra": [
    {
      "title": "Sapaoritra Tily",
      "artist": "Tily",
      "tracks": <Map<String, String>>[
        {"title": "Indreto vonona", "artist": "Tily", "cover": "assets/images/hira-sapaoritra/indretovonona.jpg","audio": " assets/musique/Hiran_nyLOMAY(SampanaMaitso)-TilyetoMadagasikara(M4A_128K).m4a"},
        {"title": "Ho tiavinay mandrakizay", "artist": "Tily", "cover": "assets/images/hira-sapaoritra/ho-tiavinay-mandrakizay.jpg","audio": "assets/musique/Hotiavinaymandrakizay(M4A_128K).m4a"},
        {"title": "Miainga Miainga", "artist": "Fiantsoana Mena", "cover": "assets/images/hira-sapaoritra/miaingamiainga-mena.jpg", "audio": "assets/musique/Hiran_nyDINIERY(TENDRO_SampanaMena)-TilyetoMadagasikara(M4A_128K).m4a"},
        {"title": "Injao misy feo", "artist": "Fiantsoana Menafify", "cover": "assets/images/hira-sapaoritra/hirafiantsonamenafify.png","audio":"assets/musique/Hirafiantsoanamenafify_Feomiantso_(M4A_128K).m4a"},
        {"title": "Sapaoritra Menafify", "artist": "Menafify", "cover": "assets/images/hira-sapaoritra/hirasapaoritramenafify.jpg", "audio":"assets/musique/Hirasapaoritramenafify(M4A_128K).m4a"},
      ],
    },
    {
      "title": "Sapaoritra Mpanazava",
      "artist": "Mpanazava",
      "tracks": <Map<String, String>>[
        {"title": "Manaparasaka", "artist": "Mpanazava", "cover": "assets/images/hira-sapaoritra/manaparasakamapanazava.jpg"},
      ],
    },
  ],
  "Sareba": [
    {
      "title":"Sareba Milay",
      "artist": "Skoto",
      "tracks":<Map<String, String>>[
        {"title": "Aoka fa fantatro", "artist": "Tily", "cover":"assets/images/guitaretily.jpg", "audio":"assets/musique/Izanovonona-Izanohanolo-tena_izanohirahina(M4A_128K).m4a"},
        {"title": "Sareba", "artist": "skoto", "cover":"assets/images/sareba/sareba.jpg","audio": "assets/musique/HIRASKOTOFILOHARémiTO.M(M4A_128K).m4a"},
      ]
    },
    {
      "title": "Sareba Tsapiky",
      "artist": "Fivondronana Amboasary Antsimo",
      "tracks": <Map<String, String>>[
        {
          "title": "Sareba Tsapiky",
          "artist": "Fivondronana Amboasary Antsimo",
          "cover": "assets/images/sareba/sarebatsapiky-fivondronana-amboasary-antsimo.jpg"},
      ]
    }
]

};

//----------data musique recemment ecoutee---------
late List<Map<String, String>> recentTracks = [
  {
    'title': 'Hira Sapaoritra',
    'artist': 'Tily',
    'cover': 'assets/images/tily.jpg',
    "audio": " assets/musique/Hotiavinaymandrakizay(M4A_128K).m4a"
  },
  {
    'title': 'Medley',
    'artist': 'Filoha Remi',
    'cover': 'assets/images/filoha remi.jpg',
    "audio": "assets/musique/HIRASKOTOFILOHARémiTO.M(M4A_128K).m4a"
  },
  {
    'title': 'Sareba',
    'artist': 'Skoto',
    'cover': 'assets/images/guitaretily.jpg',
    "audio": "  assets/musique/Izanohonamanay(M4A_128K).m4a"
  },
  {
    'title': 'RAILOVY',
    'artist': 'Hira Tily',
    'cover': 'assets/images/tily.jpg',
    "audio": " assets/musique/Izanovonona-Izanohanolo-tena_izanohirahina(M4A_128K).m4a"
  },
];

//----------data nouveaute------------
late final List<Map<String, String>> albums = [
  {
    'title': 'RAILOVY',
    'artist': 'Hira Tily',
    'cover': 'assets/images/tily.jpg',
    "audio": " assets/musique/Izanovonona-Izanohanolo-tena_izanohirahina(M4A_128K).m4a"
  },
  {
    'title': 'Sareba',
    'artist': 'Skoto',
    'cover': 'assets/images/guitaretily.jpg',
    "audio": "  assets/musique/Izanohonamanay(M4A_128K).m4a"
  },
  {
    'title': 'Medley',
    'artist': 'Filoha Remi',
    'cover': 'assets/images/filoha remi.jpg',
    "audio": "assets/musique/HIRASKOTOFILOHARémiTO.M(M4A_128K).m4a"
  },
  {
    'title': 'Hira Sapaoritra',
    'artist': 'Tily',
    'cover': 'assets/images/tily.jpg',
    "audio": " assets/musique/Hotiavinaymandrakizay(M4A_128K).m4a"
  },
];

