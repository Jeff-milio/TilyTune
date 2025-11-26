import 'package:flutter/material.dart';
import 'package:tilytune1/liste/Categories.dart';
import 'AlbumsTab.dart';
import 'ArtistesTab.dart';
import 'PlaylistsTab.dart';

class Liste extends StatefulWidget {
  @override
  _ListeState createState() => _ListeState();
}

class _ListeState extends State<Liste> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF150303),
      appBar: AppBar(
        toolbarHeight: 25,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A0F12),
                Color(0xFF501C1F),
                Color(0xF4000000)],
              begin: Alignment.bottomCenter,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        title: Text(
          "Listes",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            fontFamily: 'SpecialGothic'
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFFFFCFA0),
          labelColor: Color(0xFFFFCFA0),
          unselectedLabelColor: Color(0xFFC3C3C3),
          labelStyle: TextStyle( fontSize: 15),
          tabs: [
            Tab(text: "Playlists"),
            Tab(text: "Albums"),
            Tab(text: "Artistes"),
            Tab(text: "Categories"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PlaylistsTab(),
          AlbumsTab(),
          ArtistesTab(),
          Categories(),
        ],
      ),

    );
  }
}
//------------------------PlaylistsTab--------------------

// ---------------------- Albums -------------------------

// ---------------------- Artistes -----------------------

// ---------------------- Categories ---------------------