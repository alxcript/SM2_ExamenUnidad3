import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    final usuarios = await _databaseHelper.getUsuarios();
    setState(() {
      _usuarios = usuarios;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      body: ListView.builder(
        itemCount: _usuarios.length,
        itemBuilder: (context, index) {
          final usuario = _usuarios[index];
          return ListTile(
            title: Text('${usuario['nombre']} ${usuario['apellido']}'),
            subtitle: Text(usuario['email']),
            onTap: () {
              // Aquí puedes agregar lógica para editar o ver más detalles del usuario
            },
          );
        },
      ),
    );
  }
}
