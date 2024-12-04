import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "foodapp.db";
  static final _databaseVersion = 1;
  static final table = 'users';

  static final columnId = 'id';
  static final columnUsername = 'username';
  static final columnEmail = 'email';
  static final columnPassword = 'password';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUsername TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert(table, user);
  }

  Future<Map<String, dynamic>?> getUser(String emailOrUsername, String password) async {
    Database db = await instance.database;
    final result = await db.query(
      table,
      where: "($columnEmail = ? OR $columnUsername = ?) AND $columnPassword = ?",
      whereArgs: [emailOrUsername, emailOrUsername, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
