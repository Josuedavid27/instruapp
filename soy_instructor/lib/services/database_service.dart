import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {

  static Database? _database;

  // Obtener instancia de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Inicializar base de datos
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'paintball.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE grupos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          instructor TEXT,
          jugadores INTEGER,
          fecha TEXT,
          recargas INTEGER,
          bebidas INTEGER,
          total INTEGER
        )
        ''');
      },
    );
  }

  // Insertar grupo
  Future<int> insertarGrupo(Map<String, dynamic> grupo) async {
    final db = await database;
    return await db.insert('grupos', grupo);
  }

  // Obtener todos los grupos
  Future<List<Map<String, dynamic>>> obtenerGrupos() async {
    final db = await database;
    return await db.query('grupos');
  }
  // Obtener grupos del día
  Future<List<Map<String, dynamic>>> obtenerGruposHoy() async {

    final db = await database;

    final hoy = DateTime.now();
    final inicioDia = DateTime(hoy.year, hoy.month, hoy.day).toIso8601String();

    final resultado = await db.rawQuery(
      "SELECT * FROM grupos WHERE fecha >= ?",
      [inicioDia]
    );

    return resultado;
  }
  //obtener instructor con más ventas
  Future<Map<String, dynamic>?> obtenerTopInstructorVentas() async {

    final db = await database;  

    final resultado = await db.rawQuery('''
    SELECT instructor, SUM(total) as total
    FROM grupos
    GROUP BY instructor
    ORDER BY total DESC
    LIMIT 1
    ''');

    if (resultado.isNotEmpty) {
      return resultado.first;
    }

    return null;
  }
  // Obtener instructor con más grupos
  Future<Map<String, dynamic>?> obtenerTopInstructorGrupos() async {

    final db = await database;

    final resultado = await db.rawQuery('''
    SELECT instructor, COUNT(*) as total
    FROM grupos
    GROUP BY instructor
    ORDER BY total DESC
    LIMIT 1
    ''');

    if (resultado.isNotEmpty) {
      return resultado.first;
    }

    return null;
  }
// Obtener estadísticas del día
  Future<Map<String, dynamic>> obtenerEstadisticasHoy() async {

  final db = await database;

  final hoy = DateTime.now();
  final inicioDia = DateTime(hoy.year, hoy.month, hoy.day).toIso8601String();

  final gruposHoy = await db.rawQuery(
    "SELECT COUNT(*) as total FROM grupos WHERE fecha >= ?",
    [inicioDia]
  );

  final jugadoresHoy = await db.rawQuery(
    "SELECT SUM(jugadores) as total FROM grupos WHERE fecha >= ?",
    [inicioDia]
  );

  final ventasHoy = await db.rawQuery(
    "SELECT SUM(total) as total FROM grupos WHERE fecha >= ?",
    [inicioDia]
  );

  return {
    "grupos": gruposHoy.first["total"] ?? 0,
    "jugadores": jugadoresHoy.first["total"] ?? 0,
    "ventas": ventasHoy.first["total"] ?? 0,
  };
}
}