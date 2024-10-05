class Usuario {
  final int id_usuario; 
  final String nombre;
  final String apellido;
  final String email;
  final String contrasenia;
  final String tipoUsuario;

  Usuario({
    required this.id_usuario, 
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.contrasenia,
    required this.tipoUsuario,
  });

  // Convertir un mapa a un objeto Usuario
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id_usuario: map['id_usuario'], 
      nombre: map['nombre'],
      apellido: map['apellido'],
      email: map['email'],
      contrasenia: map['contraseña'],
      tipoUsuario: map['tipo_usuario'],
    );
  }

  // Convertir un objeto Usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_usuario': id_usuario, 
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'contraseña': contrasenia,
      'tipo_usuario': tipoUsuario,
    };
  }
}
