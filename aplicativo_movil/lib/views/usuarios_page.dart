import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';
import 'registrar_page.dart'; // Asegúrate de importar la página de registro

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Usuario> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    final usuariosData = await _dbHelper.getUsuarios();
    setState(() {
      _usuarios = usuariosData.map((usuario) => Usuario.fromMap(usuario)).toList();
    });
  }

  Future<void> _deleteUsuario(int id) async {
    await _dbHelper.deleteUsuario(id);
    _loadUsuarios();
  }

  Future<void> _navigateToRegistrarPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrarPage()),
    );

    if (result == true) {
      _loadUsuarios(); // Recargar la lista de usuarios si se registró uno nuevo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Registrados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToRegistrarPage(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _usuarios.length,
        itemBuilder: (context, index) {
          final usuario = _usuarios[index];
          return ListTile(
            title: Text('${usuario.nombre} ${usuario.apellido}'),
            subtitle: Text('Email: ${usuario.email}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteUsuario(usuario.id_usuario),
            ),
          );
        },
      ),
    );
  }
}
