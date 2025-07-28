import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import '/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  void loginUser() async {
    final String email = emailCtrl.text.trim();
    final String password = passwordCtrl.text;

    // Validación de campos vacíos
    final bool camposVacios = email.isEmpty || password.isEmpty;
    if (camposVacios) {
      mostrarMensaje("Completa todos los campos");
      return;
    }

    try {
      // Referencia a la colección "users" en Firestore
      final CollectionReference usersRef = FirebaseFirestore.instance
          .collection('users');

      // Consulta al documento que coincide con el email y la contraseña
      final Query query = usersRef
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password);

      final QuerySnapshot snapshot = await query.get();

      final bool usuarioEncontrado = snapshot.docs.isNotEmpty;

      if (usuarioEncontrado) {
        // Navegación a HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
      } else {
        mostrarMensaje("Credenciales inválidas");
      }
    } catch (e) {
      print("Error al iniciar sesión: $e");
      mostrarMensaje("Error al iniciar sesión");
    }
  }

  void mostrarMensaje(String mensaje) {
    final SnackBar snackBar = SnackBar(content: Text(mensaje));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo
              SizedBox(
                height: 200,
                child: Image.asset('assets/logo_1.png'), // Cambia tu logo aquí
              ),
              const SizedBox(height: 40),

              const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 32),

              // Email
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Contraseña
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botón de login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue, // Celeste
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Link a registro
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: const Text(
                  '¿No tenés cuenta? Registrate',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
