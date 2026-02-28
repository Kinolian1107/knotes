import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/memo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('knotes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE memos (
        id TEXT PRIMARY KEY,
        content TEXT NOT NULL,
        metadata TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<Memo?> insertMemo(Memo memo) async {
    try {
      final db = await instance.database;
      await db.insert('memos', memo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return memo;
    } catch (e) {
      // return null not throw as per CLAUDE.md
      print('Insert Error: \$e');
      return null;
    }
  }

  Future<List<Memo>?> fetchMemos() async {
    try {
      final db = await instance.database;
      final result = await db.query('memos', orderBy: 'createdAt DESC');
      return result.map((json) => Memo.fromMap(json)).toList();
    } catch (e) {
      print('Fetch Error: \$e');
      return null;
    }
  }
}
