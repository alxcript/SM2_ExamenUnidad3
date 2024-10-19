import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/historia_clinica.dart';
import 'crear_historia_clinica_page.dart';

class HistoriaClinicaPage extends StatefulWidget {
  final int idUsuario;
  final String tipoUsuario; // Puede ser 'profesional' o 'paciente'
  final String nombre;
  final String apellido;

  const HistoriaClinicaPage({
    Key? key,
    required this.idUsuario,
    required this.tipoUsuario,
    required this.nombre,
    required this.apellido,
  }) : super(key: key);

  @override
  _HistoriaClinicaPageState createState() => _HistoriaClinicaPageState();
}

class _HistoriaClinicaPageState extends State<HistoriaClinicaPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<HistoriaClinica> _historiasClinicas = [];

  @override
  void initState() {
    super.initState();
    _cargarHistoriasClinicas();
  }

  Future<void> _cargarHistoriasClinicas() async {
    List<Map<String, dynamic>> historias;

    if (widget.tipoUsuario == 'profesional') {
      historias = await _databaseHelper.getTodasLasHistoriasClinicas();
    } else {
      historias = await _databaseHelper
          .getHistoriasClinicasPorUsuario(widget.idUsuario);
    }

    setState(() {
      _historiasClinicas =
          historias.map((json) => HistoriaClinica.fromMap(json)).toList();
    });
  }

  void _agregarHistoriaClinica() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearHistoriaClinicaPage(
          idUsuario: widget.idUsuario,
          tipoUsuario: widget.tipoUsuario,
          nombre: widget.nombre,
          apellido: widget.apellido,
        ),
      ),
    ).then((_) => _cargarHistoriasClinicas());
  }

  void _eliminarHistoriaClinica(int idHistoria) async {
    await _databaseHelper.deleteHistoriaClinica(idHistoria);
    _cargarHistoriasClinicas();
  }

  void _confirmarEliminacion(int idHistoria) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Historia Clínica'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar esta historia clínica?'),
        actions: [
          TextButton(
            onPressed: () {
              _eliminarHistoriaClinica(idHistoria);
              Navigator.of(context).pop();
            },
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historias Clínicas'),
      ),
      body: Column(
        children: [
          if (widget.tipoUsuario == 'profesional') ...[
            ElevatedButton(
              onPressed: _agregarHistoriaClinica,
              child: const Text('Agregar Historia Clínica'),
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: _historiasClinicas.length,
              itemBuilder: (context, index) {
                final historia = _historiasClinicas[index];
                return ListTile(
                  title: Text('Historia #${historia.idHistoria}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Paciente: ${historia.nombrePaciente} ${historia.apellidoPaciente}'),
                      Text('Diagnóstico: ${historia.diagnostico ?? 'N/A'}'),
                      Text('Síntomas: ${historia.sintomas}'),
                    ],
                  ),
                  trailing: widget.tipoUsuario == 'profesional'
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _confirmarEliminacion(historia.idHistoria),
                        )
                      : null,
                  onTap: () {
                    // Navegación a detalles si es necesario
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
