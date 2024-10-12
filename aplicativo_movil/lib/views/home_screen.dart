// views/home_screen.dart
import 'package:flutter/material.dart';
import 'usuarios_page.dart';
import 'registrar_page.dart';
import 'login_page.dart';
import 'historia_clinica_page.dart'; // Importar la página de historias clínicas
import 'gestionar_citas_page.dart'; // Asegúrate de tener la página de gestión de citas

class HomeScreen extends StatefulWidget {
  final String tipoUsuario;
  final int idUsuario; // Agregar el ID del usuario como parámetro

  const HomeScreen({Key? key, required this.tipoUsuario, required this.idUsuario}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón visible para todos los usuarios
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoriaClinicaPage(
                      idUsuario: widget.idUsuario,
                      tipoUsuario: widget.tipoUsuario, // Pasar tipo de usuario
                    ),
                  ),
                );
              },
              child: const Text('Ver Historial Clínico'),
            ),
            // Condiciones para mostrar botones según el tipo de usuario
            if (widget.tipoUsuario == 'profesional') ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UsuariosPage()),
                  );
                },
                child: const Text('Ver Usuarios'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GestionarCitasPage()), // Asegúrate de tener esta página
                  );
                },
                child: const Text('Gestionar Citas'),
              ),
            ] else if (widget.tipoUsuario == 'paciente') ...[
              ElevatedButton(
                onPressed: () {
                  // Navegar a la página de citas o similar
                },
                child: const Text('Solicitar Cita'),
              ),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrarPage()),
                );
              },
              child: const Text('Registrar Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}