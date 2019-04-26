import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_sqf_lite/src/model/Note.dart';
import 'package:flutter_app_sqf_lite/src/screen/NoteDetail.dart';
import 'package:flutter_app_sqf_lite/src/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> lstNote;
  int nCount = 0;

  @override
  Widget build(BuildContext context) {
    //initialize note list
    if (lstNote == null) {
      lstNote = List<Note>();
    }

    updateListView();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getListViewNotes(),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add new note',
          child: Icon(Icons.add),
          onPressed: () {
            navigateToNoteDetailScreen(Note('', '', 1), 'Add Note');
          }),
    );
  }

  ListView getListViewNotes() {
    TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .subhead;

    return ListView.builder(
        itemCount: nCount,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                getPriorityColor(this.lstNote[position].priority),
                child: getPriorityIcon(this.lstNote[position].priority),
              ),
              title: Text(this.lstNote[position].title),
              subtitle: Text(this.lstNote[position].date),
              trailing: GestureDetector(
                child: Icon(Icons.delete, color: Colors.red),
                onTap: () {
                  _delete(context, lstNote[position]);
                },
              ),
              onTap: () {
                print('Item tapped');
                navigateToNoteDetailScreen(this.lstNote[position], 'Add Note');
              },
            ),
          );
        });
  }

  //get color based on priority
  Color getPriorityColor(int nPriority) {
    switch (nPriority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  //get icon based on priority
  Icon getPriorityIcon(int nPriority) {
    switch (nPriority) {
      case 1:
        return Icon(Icons.note_add,color: Colors.white);
        break;
      case 2:
        return Icon(Icons.note ,color: Colors.grey,);
        break;
      default:
        return Icon(Icons.note);
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.lstNote = noteList;
          this.nCount = noteList.length;
        });
      });
    });
  }

  //helper: delete a note from the db if exists
  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note successfully deleted');
      updateListView(); //refresh list view
    }
  }

  void _showSnackBar(BuildContext context, String stMessage) {
    final snackBar = SnackBar(
      content: Text(stMessage),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToNoteDetailScreen(Note note, String stAppbarTitle) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, stAppbarTitle);
    }));

    if (result) {
      //update list view
      updateListView();
    }
  }
}
