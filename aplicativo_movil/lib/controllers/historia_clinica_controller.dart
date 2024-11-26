import '../database/database_helper.dart';
import '../models/usuario.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoriaClinicaController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Usuario>> obtenerPacientes() async {
    return await _databaseHelper.getUsuariosPorTipo('paciente');
  }

  Future<String> generarDiagnosticoIA() async {
    String apiKey = 'AIzaSyD3ah7hOp08dubenTuGL-GekUtswQO7SGs';
    Uri url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

    final Map<String, dynamic> body = {
      'contents': [
        {
          'parts': [
            {'text': 'Fiebre y dolor de cabeza por 3 dias, cual podria ser el diagnóstico médico?.'}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Request failed: $e';
    }
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
