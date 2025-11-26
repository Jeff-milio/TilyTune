import 'package:flutter/material.dart';

class free extends StatelessWidget {
  const free({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
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
        title: Text(
          "Free",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),

      ),
      body: Scaffold(
          backgroundColor: Color(0xFF120202)
      ),
    );
  }
}

