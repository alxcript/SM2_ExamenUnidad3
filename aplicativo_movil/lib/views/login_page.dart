import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'home_screen.dart';
import 'registrar_page.dart'; // Import the RegistrarPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _contrasenaController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _iniciarSesion,
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to the registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrarPage()),
                );
              },
              child: const Text('¿No tienes una cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _iniciarSesion() async {
    final email = _emailController.text;
    final contrasena = _contrasenaController.text;

    final usuarios = await _databaseHelper.getUsuarios();
    final usuario = usuarios.firstWhere(
      (u) => u['email'] == email && u['contraseña'] == contrasena,
      orElse: () => {},
    );

    if (usuario.isNotEmpty) {
      // Usuario encontrado, redirigir a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            tipoUsuario: usuario['tipo_usuario'],
            idUsuario: usuario['id_usuario'], // Pasar ID del usuario
            nombre: usuario['nombre'], // Pasar nombre
            apellido: usuario['apellido'], // Pasar apellido
          ),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Email o contraseña incorrectos';
      });
    }
  }
}
