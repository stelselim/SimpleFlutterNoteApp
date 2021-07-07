import 'package:flutter/foundation.dart';
import 'package:stelnoteapp/application/note_model.dart';

@immutable
abstract class NoteOperations {
  Future<void> initiliazeDb();
  Future<List<Note>> getNotes();
  Future<void> addNote(Note note);
  Future<void> deleteNote(Note note);
}
