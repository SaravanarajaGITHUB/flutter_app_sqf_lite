import 'package:flutter/material.dart';
import 'package:flutter_app_sqf_lite/src/screen/NoteList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Keeper',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: NoteList(),
    );
  }
}
