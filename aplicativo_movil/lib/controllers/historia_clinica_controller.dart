import '../database/database_helper.dart';
import '../models/usuario.dart';

class HistoriaClinicaController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Usuario>> obtenerPacientes() async {
    return await _databaseHelper.getUsuariosPorTipo('paciente');
  }

  Future<void> guardarHistoriaClinica({
    required int idUsuario,
    required String diagnostico,
    required String sintomas,
    required String motivoConsulta,
    required String antecedentesPersonales,
    required String antecedentesFamiliares,
    required String alergias,
    required String medicamentosActuales,
    required String indicaciones,
    required String recomendaciones,
    required String observaciones,
    required String resultadosExamenes,
  }) async {
    final historia = {
      'id_usuario': idUsuario,
      'diagnostico': diagnostico,
      'sintomas': sintomas,
      'motivo_consulta': motivoConsulta,
      'antecedentes_personales': antecedentesPersonales,
      'antecedentes_familiares': antecedentesFamiliares,
      'alergias': alergias,
      'medicamentos_actuales': medicamentosActuales,
      'indicaciones': indicaciones,
      'recomendaciones': recomendaciones,
      'observaciones': observaciones,
      'resultados_examenes': resultadosExamenes,
    };
    await _databaseHelper.insertHistoriaClinica(historia);
  }
}
