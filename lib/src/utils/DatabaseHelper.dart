import 'package:flutter_app_sqf_lite/src/model/Note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  DatabaseHelper._singleInstance();
  static final _databaseHelper = DatabaseHelper._singleInstance();
  factory DatabaseHelper() => _databaseHelper;

  static Database _database;

  //note table
  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //get the  directory  path for  both android / IOS to store our db
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db';

    //open/create database at the given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    String query = ('CREATE TABLE $noteTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colTitle TEXT, '
        '$colDescription TEXT, '
        '$colPriority INTEGER, '
        '$colDate TEXT)');
    await db.execute(query);
  }

  //Insert operation: insert note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //update operation: update a note object & save it to database
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //delete operation: delete a note object from database
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result =
        await db.delete(noteTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

//get number of notes object from database
  Future<int> getNoteTableCount(Note note) async {
    Database db = await this.database;
    var listMap = await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    int result = Sqflite.firstIntValue(listMap);
    return result;
  }

//fetch operation: get all notes from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    //var result = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPriority ASC')
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<List<Note>> getNoteList() async {
    //get note map list first
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Note> lstNote = List<Note>();

    //loop to create note list from note map list
    for (int i = 0; i < count; i++) {
      lstNote.add(Note.fromMapObject(noteMapList[i]));
    }
    return lstNote;
  }
}
