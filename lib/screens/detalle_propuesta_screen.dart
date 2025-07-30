import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetallePropuestaScreen extends StatelessWidget {
  final Map<String, dynamic> propuesta;
  final bool esPropia;
  final String propuestaId;

  const DetallePropuestaScreen({
    super.key,
    required this.propuesta,
    required this.esPropia,
    required this.propuestaId,
  });

  @override
  Widget build(BuildContext context) {
    final titulo = propuesta['titulo'] ?? 'Sin título';
    final descripcion = propuesta['descripcion'] ?? '';
    final objetivo = propuesta['objetivo'] ?? '';
    final ubicacion = propuesta['ubicacion'] ?? '';
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final esDelUsuario = currentUserId == propuesta['usuarioId'];

    return Scaffold(
      appBar: AppBar(
        title: Text(esPropia ? 'Mi propuesta' : 'Propuesta compartida'),
        actions: esPropia
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función editar pendiente')),
                    );
                  },
                )
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Título:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(titulo),
            const SizedBox(height: 10),
            Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(descripcion),
            const SizedBox(height: 10),
            Text('Objetivo:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(objetivo),
            const SizedBox(height: 10),
            Text('Ubicación:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(ubicacion),
            const SizedBox(height: 20),

            // SOLO si no es del usuario
            if (!esDelUsuario) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('propuestas')
                      .doc(propuestaId)
                      .collection('apoyos')
                      .doc(currentUserId)
                      .set({'fecha': FieldValue.serverTimestamp()});

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Gracias por tu apoyo!')),
                  );
                },
                icon: const Icon(Icons.thumb_up),
                label: const Text('Apoyar'),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('propuestas')
                    .doc(propuestaId)
                    .collection('apoyos')
                    .snapshots(),
                builder: (context, snapshot) {
                  final totalApoyos = snapshot.data?.docs.length ?? 0;
                  return Text('Total de apoyos: $totalApoyos');
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: implementar pantalla para compartir
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función compartir pendiente')),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Compartir con contactos'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}