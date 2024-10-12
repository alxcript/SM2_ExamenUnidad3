import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/historia_clinica.dart';
import 'crear_historia_clinica_page.dart'; // Importar la página para crear historias clínicas

class HistoriaClinicaPage extends StatefulWidget {
  final int idUsuario; // ID del usuario para obtener sus historias clínicas
  final String tipoUsuario; // Tipo de usuario para mostrar el botón si es profesional

  const HistoriaClinicaPage({
    Key? key,
    required this.idUsuario,
    required this.tipoUsuario,
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
      // Si es un profesional, cargar todas las historias clínicas
      historias = await _databaseHelper.getTodasLasHistoriasClinicas();
    } else {
      // Si es un paciente, cargar solo sus historias clínicas
      historias = await _databaseHelper.getHistoriasClinicasPorUsuario(widget.idUsuario);
    }

    setState(() {
      _historiasClinicas = historias.map((json) => HistoriaClinica.fromMap(json)).toList();
    });
  }

  void _agregarHistoriaClinica() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearHistoriaClinicaPage(
          idUsuario: widget.idUsuario,
          tipoUsuario: widget.tipoUsuario, // Pasar tipo de usuario
        ),
      ),
    ).then((_) => _cargarHistoriasClinicas()); // Recargar historias clínicas después de volver
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historias Clínicas'),
      ),
      body: Column(
        children: [
          // Mostrar botón "Agregar Historia Clínica" solo para profesionales
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
                  subtitle: Text('Diagnóstico: ${historia.diagnostico ?? 'N/A'}'),
                  onTap: () {
                    // Aquí puedes agregar navegación a una página de detalles si es necesario
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
