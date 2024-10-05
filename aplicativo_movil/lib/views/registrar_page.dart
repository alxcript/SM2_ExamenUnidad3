import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';

class RegistrarPage extends StatelessWidget {
  const RegistrarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper _dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RegistrarForm(dbHelper: _dbHelper),
      ),
    );
  }
}

class RegistrarForm extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const RegistrarForm({Key? key, required this.dbHelper}) : super(key: key);

  @override
  _RegistrarFormState createState() => _RegistrarFormState();
}

class _RegistrarFormState extends State<RegistrarForm> {
  String nombre = '';
  String apellido = '';
  String email = '';
  String contrasenia = '';
  String tipoUsuario = 'paciente'; // Valor por defecto

  Future<void> _addUsuario() async {
    final usuario = Usuario(
      id_usuario: 0, // ID será manejado automáticamente por la base de datos
      nombre: nombre,
      apellido: apellido,
      email: email,
      contrasenia: contrasenia,
      tipoUsuario: tipoUsuario,
    );

    try {
      await widget.dbHelper.insertUsuario(usuario.toMap());
      Navigator.pop(context, true); // Regresar a la página anterior e indicar éxito
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) => nombre = value,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        TextField(
          onChanged: (value) => apellido = value,
          decoration: const InputDecoration(labelText: 'Apellido'),
        ),
        TextField(
          onChanged: (value) => email = value,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          onChanged: (value) => contrasenia = value,
          decoration: const InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
        ),
        DropdownButton<String>(
          value: tipoUsuario,
          onChanged: (String? newValue) {
            setState(() {
              tipoUsuario = newValue!;
            });
          },
          items: <String>['paciente', 'profesional']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: _addUsuario,
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
