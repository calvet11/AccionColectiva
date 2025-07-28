import 'package:flutter/material.dart';
import 'explorar_acciones_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '¿Qué querés hacer hoy?',
                style: TextStyle(fontSize: 18, color: Colors.lightBlue),
              ),
              // Logo
              SizedBox(
                height: 250,
                child: Image.asset(
                  'assets/logo_1.png',),
              ),
              const SizedBox(height: 10),
               //Slogan
               const Text(
                'Nos visibiliza,organiza y fortalece.Nos necesitamos.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height:40),
              // Botón 1: Crear acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     
                    // Navegar a crear acción
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Crear una acción',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botón 2: Explorar acciones
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                       context,
    MaterialPageRoute(builder: (context) => const ExplorarAccionesScreen()),
  );
                    
                    // Navegar a explorar acciones
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.lightBlue),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Explorar acciones',
                    style: TextStyle(fontSize: 18, color: Colors.lightBlue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔽 Barra inferior de navegación
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Nodos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        // onTap lo implementás después
        onTap: (index) {},
      ),
    );
  }
}
