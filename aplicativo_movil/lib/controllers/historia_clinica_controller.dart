// historia_clinica_controller.dart

import '../database/database_helper.dart';

class HistoriaClinicaController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> obtenerPacientes() async {
    final usuarios = await _databaseHelper.getUsuarios();
    return usuarios.where((usuario) => usuario['tipo_usuario'] == 'paciente').toList();
  }

  Future<List<Map<String, dynamic>>> obtenerHistoriasClinicasPorUsuario(int idUsuario) async {
    return await _databaseHelper.getHistoriasClinicasPorUsuario(idUsuario);
  }

  Future<void> crearHistoriaClinica(int idUsuario, String diagnostico, String tratamientos, String observaciones) async {
    final historia = {
      'id_usuario': idUsuario,
      'diagnostico': diagnostico,
      'tratamientos': tratamientos,
      'observaciones': observaciones,
    };
    await _databaseHelper.insertHistoriaClinica(historia);
  }
}
