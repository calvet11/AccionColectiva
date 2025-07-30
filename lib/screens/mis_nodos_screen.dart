import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class MisNodosScreen extends StatefulWidget {
  const MisNodosScreen({super.key});

  @override
  State<MisNodosScreen> createState() => _MisNodosScreenState();
}

class _MisNodosScreenState extends State<MisNodosScreen> {
  final TextEditingController emailController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> buscarYAgregarNodo() async {
    final emailIngresado = emailController.text.trim();

    if (emailIngresado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresá un correo')),
      );
      return;
    }

    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailIngresado)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no encontrado')),
        );
        return;
      }

      final doc = query.docs.first;
      final nodoUid = doc.id;

      // Evitar agregarse a uno mismo
      if (nodoUid == currentUser!.uid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No podés agregarte a vos mismo')),
        );
        return;
      }

      final nodoData = doc.data();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('Nodos')
          .doc(nodoUid)
          .set({
        'username': nodoData['username'],
        'email': nodoData['email'],
        'userId': nodoUid, 
      });

      emailController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nodo agregado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agregar nodo')),
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis nodos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo del nodo',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: buscarYAgregarNodo,
              child: const Text('Agregar nodo'),
            ),
          ],
        ),
      ),
    );
  }
}