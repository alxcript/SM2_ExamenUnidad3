import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'gestion_historia_clinica.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Crear tabla Usuarios
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Usuarios (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        apellido TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        contraseña TEXT NOT NULL,
        tipo_usuario TEXT CHECK(tipo_usuario IN ('paciente', 'profesional')),
        fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
        ultimo_acceso DATETIME DEFAULT NULL
      )
    ''');

    // Crear tabla Historias Clínicas
    await db.execute('''
        CREATE TABLE IF NOT EXISTS Historias_Clinicas (
            id_historia INTEGER PRIMARY KEY AUTOINCREMENT,
            id_usuario INTEGER NOT NULL,
            fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
            fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP, -- Solo inicial
            diagnostico TEXT,
            tratamientos TEXT,
            observaciones TEXT,
            FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
        )
    ''');

    // Crear tabla Citas Médicas
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Citas_Medicas (
        id_cita INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        id_profesional INTEGER NOT NULL,
        fecha_cita DATETIME NOT NULL,
        estado TEXT CHECK(estado IN ('pendiente', 'confirmada', 'cancelada')),
        observaciones TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
        FOREIGN KEY (id_profesional) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
      )
    ''');

    // Crear tabla Mensajes del Asistente Virtual
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Mensajes_Asistente (
        id_mensaje INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        mensaje TEXT NOT NULL,
        respuesta TEXT,
        fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
      )
    ''');

    // Crear tabla Historial de Accesos
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Historial_Accesos (
        id_acceso INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        fecha_acceso DATETIME DEFAULT CURRENT_TIMESTAMP,
        direccion_ip TEXT,
        tipo_dispositivo TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
      )
    ''');
  }

  // Métodos para insertar, obtener, actualizar y eliminar

  // Método para insertar un usuario
  Future<void> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    await db.insert('Usuarios', usuario);
  }

// Método para obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await database;
    return await db.query('Usuarios');
  }

// Método para actualizar un usuario
  Future<int> updateUsuario(int id, Map<String, dynamic> usuario) async {
    final db = await database;
    return await db
        .update('Usuarios', usuario, where: 'id_usuario = ?', whereArgs: [id]);
  }

// Método para eliminar un usuario
  Future<int> deleteUsuario(int id) async {
    final db = await database;
    return await db
        .delete('Usuarios', where: 'id_usuario = ?', whereArgs: [id]);
  }
}
