import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'SplashScreen/SplashScreen.dart';

const SUPABASE_URL = 'https://hytmvlbmyeinrgoklrus.supabase.co'; // Exemple: 'https://xyz.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh5dG12bGJteWVpbnJnb2tscnVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQwNDUxODksImV4cCI6MjA3OTYyMTE4OX0.01yEMrx3s9F53W5VCAkfDQMLxwhFfawJuzUxBRLDrf4';

Future<void> main() async {
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      title: "Tilytune",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
          useMaterial3: true),
      home: AnimatedSplashScreen(),
    );
  }
}
