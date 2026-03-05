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
          bebidas INTEGER
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
}