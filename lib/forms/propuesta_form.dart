import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropuestaForm extends StatefulWidget {
  const PropuestaForm({super.key});

  @override
  State<PropuestaForm> createState() => _PropuestaFormState();
}

class _PropuestaFormState extends State<PropuestaForm> {
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final objetivoController = TextEditingController();
  final plazoController = TextEditingController();
  final ubicacionController = TextEditingController();

  String? categoriaSeleccionada;
  bool admiteSugerencias = true;

  final List<String> categorias = [
    'Salud',
    'Ambiente',
    'Educación',
    'Seguridad',
    'Transporte',
    'Otros',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Título de la acción *'),
          TextField(
            controller: tituloController,
            maxLength: 80,
            decoration: const InputDecoration(hintText: 'Ej: Mejorar iluminación en la plaza'),
          ),
          const SizedBox(height: 10),
          const Text('Descripción *'),
          TextField(
            controller: descripcionController,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Describa el problema o la idea...'),
          ),
          const SizedBox(height: 10),
          const Text('Categoría *'),
          DropdownButton<String>(
            value: categoriaSeleccionada,
            hint: const Text('Seleccionar categoría'),
            items: categorias.map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat));
            }).toList(),
            onChanged: (value) {
              setState(() => categoriaSeleccionada = value);
            },
          ),
          const SizedBox(height: 10),
          const Text('Ubicación asociada *'),
          TextField(
            controller: ubicacionController,
            decoration: const InputDecoration(hintText: 'Ej: Barrio Centro, Córdoba'),
          ),
          const SizedBox(height: 10),
          const Text('Imágenes (hasta 3)'),
          ElevatedButton.icon(
            onPressed: () {
              // Aquí podés implementar un picker de imágenes
            },
            icon: const Icon(Icons.image),
            label: const Text('Subir imágenes'),
          ),
          const SizedBox(height: 10),
          const Text('Objetivo específico *'),
          TextField(
            controller: objetivoController,
            decoration: const InputDecoration(hintText: 'Ej: Reunir 100 firmas en 30 días'),
          ),
          const SizedBox(height: 10),
          const Text('Plazo estimado para reunir apoyos *'),
          TextField(
            controller: plazoController,
            decoration: const InputDecoration(hintText: 'Ej: 30 días'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          const Text('¿Admite sugerencias públicas? *'),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: admiteSugerencias,
                onChanged: (value) => setState(() => admiteSugerencias = value!),
              ),
              const Text('Sí'),
              Radio<bool>(
                value: false,
                groupValue: admiteSugerencias,
                onChanged: (value) => setState(() => admiteSugerencias = value!),
              ),
              const Text('No'),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debes iniciar sesión para crear una acción')),
                );
                return;
              }

              try {
                await FirebaseFirestore.instance.collection('propuestas').add({
                  'usuarioId': user.uid,
                  'titulo': tituloController.text.trim(),
                  'descripcion': descripcionController.text.trim(),
                  'categoria': categoriaSeleccionada,
                  'ubicacion': ubicacionController.text.trim(),
                  'objetivo': objetivoController.text.trim(),
                  'plazo': int.tryParse(plazoController.text.trim()) ?? 0,
                  'admiteSugerencias': admiteSugerencias,
                  'fechaCreacion': FieldValue.serverTimestamp(),
                });

                if (context.mounted) Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('La propuesta se guardó correctamente.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al guardar en Firestore: $e')),
                );
              }
            },
            child: const Text('Guardar propuesta'),
          ),
        ],
      ),
    );
  }
}