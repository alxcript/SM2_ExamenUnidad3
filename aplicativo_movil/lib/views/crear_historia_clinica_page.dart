import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'home_screen.dart'; // Asegúrate de importar HomeScreen
import '../models/usuario.dart'; // Importar el modelo de Usuario

class CrearHistoriaClinicaPage extends StatefulWidget {
  final int idUsuario; // ID del usuario (profesional)
  final String tipoUsuario; // Tipo de usuario (profesional)

  const CrearHistoriaClinicaPage({
    Key? key,
    required this.idUsuario,
    required this.tipoUsuario,
  }) : super(key: key);

  @override
  _CrearHistoriaClinicaPageState createState() => _CrearHistoriaClinicaPageState();
}

class _CrearHistoriaClinicaPageState extends State<CrearHistoriaClinicaPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _diagnosticoController = TextEditingController();
  final TextEditingController _tratamientosController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();

  List<Usuario> _pacientes = []; // Lista de pacientes
  Usuario? _selectedPaciente; // Paciente seleccionado

  @override
  void initState() {
    super.initState();
    _cargarPacientes();
  }

  Future<void> _cargarPacientes() async {
    final pacientes = await _databaseHelper.getUsuariosPorTipo('paciente');
    setState(() {
      _pacientes = pacientes;
    });
  }

  void _guardarHistoriaClinica() async {
    if (_selectedPaciente == null) {
      // Mostrar un mensaje de error si no se ha seleccionado un paciente
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona un paciente.')),
      );
      return;
    }

    final historia = {
      'id_usuario': _selectedPaciente!.id, // Usar el ID del paciente seleccionado
      'diagnostico': _diagnosticoController.text,
      'tratamientos': _tratamientosController.text,
      'observaciones': _observacionesController.text,
    };

    await _databaseHelper.insertHistoriaClinica(historia);

    // Regresar a HomeScreen después de guardar
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          tipoUsuario: widget.tipoUsuario,
          idUsuario: widget.idUsuario,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Historia Clínica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Usuario?>(
              hint: const Text('Selecciona un paciente'),
              value: _selectedPaciente,
              onChanged: (Usuario? nuevoPaciente) {
                setState(() {
                  _selectedPaciente = nuevoPaciente;
                });
              },
              items: _pacientes.map((Usuario paciente) {
                return DropdownMenuItem<Usuario?>(
                  value: paciente,
                  child: Text('${paciente.nombre} ${paciente.apellido}'),
                );
              }).toList(),
            ),
            TextField(
              controller: _diagnosticoController,
              decoration: const InputDecoration(labelText: 'Diagnóstico'),
            ),
            TextField(
              controller: _tratamientosController,
              decoration: const InputDecoration(labelText: 'Tratamientos'),
            ),
            TextField(
              controller: _observacionesController,
              decoration: const InputDecoration(labelText: 'Observaciones'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarHistoriaClinica,
              child: const Text('Guardar Historia Clínica'),
            ),
          ],
        ),
      ),
    );
  }
}
