// models/historia_clinica.dart
class HistoriaClinica {
  final int idHistoria;
  final int idUsuario;
  final String? diagnostico;
  final String? tratamientos;
  final String? observaciones;

  HistoriaClinica({
    required this.idHistoria,
    required this.idUsuario,
    this.diagnostico,
    this.tratamientos,
    this.observaciones,
  });

  factory HistoriaClinica.fromMap(Map<String, dynamic> map) {
    return HistoriaClinica(
      idHistoria: map['id_historia'],
      idUsuario: map['id_usuario'],
      diagnostico: map['diagnostico'],
      tratamientos: map['tratamientos'],
      observaciones: map['observaciones'],
    );
  }
}
