import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../models/memo.dart';
import '../models/category.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('knotes_v2.db'); // New DB version for complex schema
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        isDefault INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE memos (
        id TEXT PRIMARY KEY,
        url TEXT,
        title TEXT,
        notes TEXT,
        ogTitle TEXT,
        imageUrl TEXT,
        categoryId TEXT,
        tags TEXT,
        isPinned INTEGER NOT NULL,
        isUnread INTEGER NOT NULL,
        isArchived INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Insert Default Categories
    final batch = db.batch();
    batch.insert('categories', Category(id: 'cat_all', name: '全部分類', isDefault: true).toMap());
    batch.insert('categories', Category(id: 'cat_general', name: '一般', isDefault: true).toMap());
    batch.insert('categories', Category(id: 'cat_readlater', name: '稍後閱讀', isDefault: true).toMap());
    batch.insert('categories', Category(id: 'cat_threads', name: 'Threads', isDefault: true).toMap());
    await batch.commit();
  }

  // --- Category Operations ---
  Future<List<Category>?> fetchCategories() async {
    try {
      final db = await instance.database;
      final result = await db.query('categories');
      return result.map((json) => Category.fromMap(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<Category?> insertCategory(Category category) async {
    try {
      final db = await instance.database;
      await db.insert('categories', category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return category;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final db = await instance.database;
      await db.delete('categories', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }

  // --- Memo Operations ---
  Future<List<Memo>?> fetchMemos() async {
    try {
      final db = await instance.database;
      final result = await db.query('memos', orderBy: 'createdAt DESC');
      return result.map((json) => Memo.fromMap(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<Memo?> insertMemo(Memo memo) async {
    try {
      final db = await instance.database;
      await db.insert('memos', memo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return memo;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateMemo(Memo memo) async {
    try {
      final db = await instance.database;
      await db.update('memos', memo.toMap(), where: 'id = ?', whereArgs: [memo.id]);
      return true;
    } catch (e) {
      return false;
    }
  }

    Future<bool> deleteMemo(String id) async {
    try {
      final db = await instance.database;
      await db.delete('memos', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('memos');
    await db.delete('categories', where: 'isDefault = ?', whereArgs: [0]);
  }
}
