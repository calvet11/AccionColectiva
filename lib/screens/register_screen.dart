import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  RegisterScreen({super.key});

  void registerUser(BuildContext context) async {
    final String usernameIngresado = usernameCtrl.text.trim();
    final String emailIngresado = emailCtrl.text.trim();
    final String passwordIngresado = passwordCtrl.text;

    if (usernameIngresado.isEmpty ||
        emailIngresado.isEmpty ||
        passwordIngresado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    try {
      // Registrar con Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailIngresado,
        password: passwordIngresado,
      );

      // Guardar datos adicionales en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': usernameIngresado,
        'email': emailIngresado,
      });

      // Limpiar campos
      usernameCtrl.clear();
      emailCtrl.clear();
      passwordCtrl.clear();

      // Redirigir a Login o Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      print('Código de error Firebase: ${e.code}');
      String mensaje = 'Error al registrar';
      if (e.code == 'email-already-in-use') {
        mensaje = 'Ese correo ya está en uso';
      } else if (e.code == 'invalid-email') {
        mensaje = 'Correo inválido';
      } else if (e.code == 'weak-password') {
        mensaje = 'Contraseña demasiado débil';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    } catch (e) {
      print('Error inesperado: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error inesperado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrarse")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => registerUser(context),
              child: const Text('Registrarse'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}