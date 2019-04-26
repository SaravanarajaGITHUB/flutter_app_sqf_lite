import 'package:flutter/material.dart';
import 'package:flutter_app_sqf_lite/src/model/Note.dart';
import 'package:flutter_app_sqf_lite/src/utils/DatabaseHelper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final Note note;
  final String stAppbarTitle;

  NoteDetail(this.note, this.stAppbarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.stAppbarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  var _formKey = GlobalKey<FormState>();
  var _priority = ['High', 'Low'];
  DatabaseHelper databaseHelper = DatabaseHelper();
  Note note;
  String stAppbarTitle;

  TextEditingController tecTitle = TextEditingController();
  TextEditingController tecDescription = TextEditingController();

  NoteDetailState(this.note, this.stAppbarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    this.tecTitle.text = this.note.title;
    this.tecDescription.text = this.note.description;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
          title: Text(stAppbarTitle),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: _priority.map((String dropdownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropdownStringItem,
                            child: Text(dropdownStringItem),
                          );
                        }).toList(),
                        style: textStyle,
                        value: getPriorityAsString(note.priority),
                        onChanged: (value) {
                          setState(() {
                            updatePriorityAsInt(value);
                          });
                        },
                      ),
                    )),
                //children: edit text title
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: tecTitle,
                    style: textStyle,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter Title';
                      } else {
                        //update title
                        updateTitle();
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    /*onChanged: (value) {

                    },*/
                  ),
                ),
                //children: edit text Description
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: tecDescription,
                    style: textStyle,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    onChanged: (value) {
                      //update description
                      updateDescription();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Save',
                                textScaleFactor: 1.5,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _save();
                              }
                            }),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Delete',
                                textScaleFactor: 1.5,
                              ),
                            ),
                            onPressed: () {
                              _delete();
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getPriorityAsString(int value) {
    switch (value) {
      case 1:
        return _priority[0];
        break;
      case 2:
        return _priority[1];
        break;
      default:
        return _priority[0];
    }
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  //update the title of note object
  void updateTitle() {
    note.title = tecTitle.text;
  }

  //update the description of the note object
  void updateDescription() {
    note.description = tecDescription.text;
  }

  //save note from database
  void _save() async {
    moveToLastScreen();
    int result;
    note.date = DateFormat.yMMM().format(DateTime.now());
    if (note.id == null) {
      //case 1: new note
      await databaseHelper.insertNote(note);
    } else {
      //case 2: update note
      await databaseHelper.updateNote(note);
    }

    if (result != 0) {
      _showAlertDialogue('status', 'Notes saved successfully!');
    } else {
      _showAlertDialogue('status', 'Problem in saving notes!');
    }
  }

  //delete note from database
  void _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDialogue('Status', 'No Note was deleted');
    }

    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialogue('status', 'Notes deleted successfully!');
    } else {
      _showAlertDialogue('status', 'Problem in deleting notes!');
    }
  }

  _showAlertDialogue(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
