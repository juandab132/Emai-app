import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static Database? _db;

  static Future<void> initDB() async {
    final path = join(await getDatabasesPath(), 'emai_app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE examenes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            descripcion TEXT,
            fecha TEXT,
            imagen TEXT,
            informe TEXT,
            completado INTEGER
          )
        ''');
      },
    );
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    return await _db!.insert(table, data);
  }

  static Future<List<Map<String, dynamic>>> getAll(String table) async {
    return await _db!.query(table);
  }
}
