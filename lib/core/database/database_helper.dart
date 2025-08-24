import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// A basic SQLite database helper.
///
/// This class exposes a singleton instance for accessing a single
/// database connection throughout the app. It handles creating the
/// database file in the documents directory, opening the database,
/// and providing a hook for creating tables on first launch. You can
/// extend this class with helper methods for queries, inserts and
/// updates as your app grows.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  /// Returns the cached database instance if available, otherwise
  /// initializes it. Always returns the same instance once opened.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('yominero.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = join(dir.path, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Called when creating the database for the first time.
  ///
  /// Use this method to create the necessary tables. For example:
  /// await db.execute('''CREATE TABLE posts(id TEXT PRIMARY KEY, title TEXT, content TEXT, likes INTEGER)''');
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        likes INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }

  // Example helper methods (can be expanded later)
  Future<int> insertPost(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('posts', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await database;
    return db.query('posts', orderBy: 'rowid DESC');
  }

  /// Closes the database. Call this when the application is disposed.
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
