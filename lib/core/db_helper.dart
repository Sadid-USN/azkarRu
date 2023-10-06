import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LikeDBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "like";

  LikeDBHelper() {
    initDB();
  }

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String path = join(await getDatabasesPath(), 'like.db');
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          print("Great work! The DB successfully created");
          await db.execute('''
            CREATE TABLE $_tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              chapterId INTEGER,
              liked INTEGER
            )
          ''');
        },
      );
    } catch (error) {
      print(error);
    }
  }

  Future<bool> isChapterLiked(int chapterId) async {
    if (_db == null) {
      return false;
    }

    final result = await _db!.query(
      _tableName,
      where: 'chapterId = ?',
      whereArgs: [chapterId],
    );

    return result.isNotEmpty;
  }

  Future<void> likeChapter(int chapterId) async {
    if (_db == null) {
      return;
    }

    final isLiked = await isChapterLiked(chapterId);
    if (!isLiked) {
      await _db!.insert(
        _tableName,
        {'chapterId': chapterId, 'liked': 1},
      );
    }
  }

  Future<void> unlikeChapter(int chapterId) async {
    if (_db == null) {
      return;
    }

    await _db!.delete(
      _tableName,
      where: 'chapterId = ?',
      whereArgs: [chapterId],
    );
  }
}
