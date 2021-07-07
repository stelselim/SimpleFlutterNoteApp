import 'package:flutter/material.dart';
import 'package:stelnoteapp/application/note_model.dart';
import 'package:stelnoteapp/infrastructure/repositories/note_repository.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  List<Note> notes = [];

  Future deleteNote(Note note) async {
    try {
      final noteOperationRepository = NoteOperationsRepository();
      await noteOperationRepository.deleteNote(note);
      final _notes = await noteOperationRepository.getNotes();
      setState(() {
        notes = _notes;
      });
    } catch (e) {
      print(e);
    }
  }

  Future connectDb() async {
    try {
      final noteOperationRepository = NoteOperationsRepository();
      final _notes = await noteOperationRepository.getNotes();
      setState(() {
        notes = _notes;
      });
    } catch (e) {
      print(e);
    }
  }

  Future addNote(String title, String note) async {
    try {
      final noteOperationRepository = NoteOperationsRepository();
      await noteOperationRepository.addNote(Note(
        note: note,
        title: title,
      ));
      final _notes = await noteOperationRepository.getNotes();
      setState(() {
        notes = _notes;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    connectDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: "Note"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (titleController.text == "") {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("No Title"),
                        content: Text("Add a title to save this note"),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Okay"),
                          )
                        ],
                      ),
                    );
                    return;
                  }
                  await addNote(titleController.text, noteController.text);
                  titleController.clear();
                  noteController.clear();
                },
                child: Text("Save"),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      notes.elementAt(index).title,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      notes.elementAt(index).note,
                      textAlign: TextAlign.center,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteNote(
                        notes.elementAt(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
