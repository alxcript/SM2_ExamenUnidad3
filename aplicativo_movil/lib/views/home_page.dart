import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Importa la clase DatabaseHelper
import '../models/usuario.dart'; // Asegúrate de tener tu modelo Usuario

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Usuario> _usuarios = []; // Lista de Usuario

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

  Future<void> _addUsuario() async {
    // Muestra un diálogo para agregar un nuevo usuario
    final nuevoUsuario = await showDialog<Usuario?>( 
      context: context,
      builder: (context) {
        String nombre = '';
        String apellido = '';
        String email = '';
        String contrasenia = '';
        String tipoUsuario = 'paciente'; // Valor por defecto

        return AlertDialog(
          title: const Text('Agregar Usuario'),
          content: SingleChildScrollView( // Permite desplazamiento si hay mucho contenido
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final usuario = Usuario(
                  id_usuario: 0, // ID será manejado automáticamente por la base de datos
                  nombre: nombre,
                  apellido: apellido,
                  email: email,
                  contrasenia: contrasenia,
                  tipoUsuario: tipoUsuario,
                );
                Navigator.pop(context, usuario);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );

    if (nuevoUsuario != null) {
      await _dbHelper.insertUsuario(nuevoUsuario.toMap());
      _loadUsuarios(); // Recargar la lista de usuarios después de agregar
    }
  }

  Future<void> _deleteUsuario(int id) async {
    await _dbHelper.deleteUsuario(id);
    _loadUsuarios(); // Recargar la lista de usuarios después de eliminar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addUsuario,
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
              onPressed: () => _deleteUsuario(usuario.id_usuario), // Usa id_usuario
            ),
          );
        },
      ),
    );
  }
}
