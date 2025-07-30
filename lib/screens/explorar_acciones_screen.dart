import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:accioncolectiva/screens/detalle_propuesta_screen.dart';

class ExplorarAccionesScreen extends StatefulWidget {
  const ExplorarAccionesScreen({super.key});

  @override
  State<ExplorarAccionesScreen> createState() => _ExplorarAccionesScreenState();
}

class _ExplorarAccionesScreenState extends State<ExplorarAccionesScreen> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<List<Map<String, dynamic>>> cargarPropuestas() async {
    if (currentUserId == null) return [];

    final firestore = FirebaseFirestore.instance;

    // Mis propuestas
    final propiasSnap = await firestore
        .collection('propuestas')
        .where('usuarioId', isEqualTo: currentUserId)
        .get();

    // Propuestas donde fui autorizado
    final autorizadasSnap = await firestore
        .collection('propuestas')
        .where('autorizados', arrayContains: currentUserId)
        .get();

    // Las propias las marcamos con tipo = 'Propia'
    final propias = propiasSnap.docs.map((doc) {
      final data = doc.data();
      data['tipo'] = 'Propia';
      return data;
    }).toList();

    // Las autorizadas las marcamos con tipo = 'Autorizada'
    final autorizadas = autorizadasSnap.docs.map((doc) {
      final data = doc.data();
      data['tipo'] = 'Autorizada';
      return data;
    }).where((data) => data['usuarioId'] != currentUserId).toList();

    return [...propias, ...autorizadas];
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: Text('Debes iniciar sesión')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Explorar acciones')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: cargarPropuestas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final propuestas = snapshot.data!;
          if (propuestas.isEmpty) {
            return const Center(child: Text('No hay acciones disponibles.'));
          }

          return ListView.builder(
            itemCount: propuestas.length,
            itemBuilder: (context, index) {
              final propuesta = propuestas[index];
              final titulo = propuesta['titulo'] ?? 'Sin título';
              final descripcion = propuesta['descripcion'] ?? '';
              final tipo = propuesta['tipo']; // 'Propia' o 'Autorizada'

              return ListTile(
                title: Text(titulo),
                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DetallePropuestaScreen(
        propuesta: propuesta,
        esPropia: tipo == 'Propia',
      ),
    ),
  );
},
                subtitle: Text(descripcion),
                trailing: Text(
                  tipo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tipo == 'Propia' ? Colors.green : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}