import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../forms/propuesta_form.dart';

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
  return const PropuestaForm();
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