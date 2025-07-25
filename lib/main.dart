import 'package:flutter/material.dart';
import '/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // importá este archivo generado

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <- aquí usás las opciones
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}