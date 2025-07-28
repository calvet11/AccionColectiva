import 'package:flutter/material.dart';

class ExplorarAccionesScreen extends StatelessWidget {
  const ExplorarAccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar acciones')),
      body: const Center(
        child: Text('Aquí se mostrarán las acciones disponibles'),
      ),
    );
  }
}