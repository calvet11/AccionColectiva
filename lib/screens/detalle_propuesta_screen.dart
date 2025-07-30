import 'package:flutter/material.dart';

class DetallePropuestaScreen extends StatelessWidget {
  final Map<String, dynamic> propuesta;
  final bool esPropia;

  const DetallePropuestaScreen({
    super.key,
    required this.propuesta,
    required this.esPropia,
  });

  @override
  Widget build(BuildContext context) {
    final titulo = propuesta['titulo'] ?? 'Sin título';
    final descripcion = propuesta['descripcion'] ?? '';
    final objetivo = propuesta['objetivo'] ?? '';
    final ubicacion = propuesta['ubicacion'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(esPropia ? 'Mi propuesta' : 'Propuesta compartida'),
        actions: esPropia
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: abrir pantalla para editar
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      ),
    );
  }
}