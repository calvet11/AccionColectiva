import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

final user = FirebaseAuth.instance.currentUser;
final userId = user?.uid; // Puede ser null si no está logueado

class CrearAccionScreen extends StatefulWidget {
  const CrearAccionScreen({super.key});

  @override
  State<CrearAccionScreen> createState() => _CrearAccionScreenState();
}

class _CrearAccionScreenState extends State<CrearAccionScreen> {
  String? tipoAccion;

  final List<String> tiposAccion = [
    'Propuesta / Moción',
    'Declaración / Opinión',
    'Alerta',
    'Pedido de Apoyo',
    'Ofrecimiento',
    'Búsqueda',
    'Reclamo',
    'Información',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Acción'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
      child :Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccione tipo de acción:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: tipoAccion,
              hint: const Text('Elija un tipo'),
              items: tiposAccion
                  .map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(tipo),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  tipoAccion = value;
                });
              },
            ),
            const SizedBox(height: 20),
            if (tipoAccion == 'Propuesta / Moción') _camposPropuesta(),
           // if (tipoAccion == 'Declaración / Opinión') _camposDeclaracion(),
           // if (tipoAccion == 'Alerta') _camposAlerta(),
           // if (tipoAccion == 'Pedido de Apoyo') _camposPedidoApoyo(),
           // if (tipoAccion == 'Ofrecimiento') _camposOfrecimiento(),
           // if (tipoAccion == 'Búsqueda') _camposBusqueda(),
           // if (tipoAccion == 'Reclamo') _camposReclamo(),
           // if (tipoAccion == 'Información') _camposInformacion(),
          ],
        ),
      ),
    ),
    );
  }
//Aqui comienza el campo propuesta_mocion
  Widget _camposPropuesta() {
   final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController objetivoController = TextEditingController();
  final TextEditingController plazoController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  String? categoriaSeleccionada;
  bool admiteSugerencias = true;

  List<String> categorias = [
    'Salud',
    'Ambiente',
    'Educación',
    'Seguridad',
    'Transporte',
    'Otros',
  ];

  return StatefulBuilder(
    builder: (context, setInnerState) {
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
                setInnerState(() {
                  categoriaSeleccionada = value;
                });
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
                  onChanged: (value) {
                    setInnerState(() => admiteSugerencias = value!);
                  },
                ),
                const Text('Sí'),
                Radio<bool>(
                  value: false,
                  groupValue: admiteSugerencias,
                  onChanged: (value) {
                    setInnerState(() => admiteSugerencias = value!);
                  },
                ),
                const Text('No'),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // El usuario no está logueado, manejá este caso (ej: pedir login)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Debes iniciar sesión para crear una acción')),
    );
    return;
  }

  try {
    await FirebaseFirestore.instance.collection('propuestas').add({
      'usuarioId': user.uid,  // <-- Guardamos el ID del usuario aquí
      'titulo': tituloController.text.trim(),
      'descripcion': descripcionController.text.trim(),
      'categoria': categoriaSeleccionada,
      'ubicacion': ubicacionController.text.trim(),
      'objetivo': objetivoController.text.trim(),
      'plazo': int.tryParse(plazoController.text.trim()) ?? 0,
      'admiteSugerencias': admiteSugerencias,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);

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
    },
  );
  }
  Widget _camposDeclaracion() {
    return const Text('Campos para Declaración / Opinión');
  }

  Widget _camposAlerta() {
    return const Text('Campos para Alerta');
  }

  Widget _camposPedidoApoyo() {
    return const Text('Campos para Pedido de Apoyo');
  }

  Widget _camposOfrecimiento() {
    return const Text('Campos para Ofrecimiento');
  }

  Widget _camposBusqueda() {
    return const Text('Campos para Búsqueda');
  }

  Widget _camposReclamo() {
    return const Text('Campos para Reclamo');
  }

  Widget _camposInformacion() {
    return const Text('Campos para Información');
  }
}