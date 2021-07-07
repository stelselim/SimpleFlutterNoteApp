import 'package:sqflite/sqflite.dart';
import 'package:stelnoteapp/application/note_model.dart';
import 'package:stelnoteapp/domain/note_operations.dart';

const NOTE_DATABASE_PATH = "note_db.db";
const NOTE_TABLE = "NOTES";

class NoteOperationsRepository extends NoteOperations {
  @override
  Future<void> addNote(Note note) async {
    final exist = await databaseExists(NOTE_DATABASE_PATH);
    if (exist) {
      print("Exist");
      var db = await openDatabase(NOTE_DATABASE_PATH);

      await db.insert(NOTE_TABLE, note.toMap());
    } else {
      print("Create");
      var db = await openDatabase(
        NOTE_DATABASE_PATH,
        version: 1,
        onCreate: onCreate,
      );

      await db.insert(NOTE_TABLE, note.toMap());
    }
  }

  @override
  Future<void> deleteNote(Note note) async {
    final exist = await databaseExists(NOTE_DATABASE_PATH);
    if (exist) {
      var db = await openDatabase(NOTE_DATABASE_PATH);
      await db
          .rawDelete("DELETE FROM $NOTE_TABLE WHERE title = ?", [note.title]);
    }
  }

  @override
  Future<List<Note>> getNotes() async {
    final exist = await databaseExists(NOTE_DATABASE_PATH);
    if (exist) {
      var db = await openDatabase(NOTE_DATABASE_PATH);
      final data = await db.rawQuery("SELECT * FROM $NOTE_TABLE");
      if (data.length != 0) {
        return data.map((e) => Note.fromMap(e)).toList();
      }
      return [];
    }
    return [];
  }

  @override
  Future<void> initiliazeDb() async {}

  static onCreate(Database db, int version) async {
    // Database is created, create the table
    await db.execute(
        "CREATE TABLE $NOTE_TABLE (id INTEGER PRIMARY KEY,title TEXT, note TEXT)");
  }
}
