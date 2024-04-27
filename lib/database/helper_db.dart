import 'package:myapp/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

// Init DB
class UserDbProvider {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();

    final path = join(directory.path, "users.db");
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        """
        CREATE TABLE Users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imageUrl TEXT,
        email TEXT)
        """,
      );
    });
  }

// Tambah User
  Future<int> addUser(User user) async {
    final db = await init();
    return db.insert(
      "Users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Fetch User list
  Future<List<User>> fetchUsers() async {
    final db = await init();

    final maps = await db.query("Users");

    return List.generate(maps.length, (index) {
      return User(
        id: maps[index]['id'] as int,
        name: maps[index]['name'].toString(),
        imageUrl: maps[index]['imageUrl'].toString(),
        email: maps[index]['email'].toString(),
      );
    });
  }

  // Delete user
  Future<int> deleteUser(int id) async {
    final db = await init();

    int result = await db.delete("Users",
        where: "id = ?",
        whereArgs: [id]);

    return result;
  }

  // Update User
  Future<int> updateUser(int id, User user) async {
    final db = await init();

    int result = await db.update("Users", user.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }
}