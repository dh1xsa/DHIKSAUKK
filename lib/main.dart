import 'package:coba1/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://nkpqaapnjglqysijsekj.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5rcHFhYXBuamdscXlzaWpzZWtqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNjEwMDUsImV4cCI6MjA1NzkzNzAwNX0.eUZvJxQpkpSZYwsECI8V3Okij1bFC2Fn7J-XaszL-IA",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}