import 'package:flutter/material.dart';
import 'package:jobnote/Screen/notes_list.dart';
import 'package:jobnote/Screen/notes_detail.dart';
import 'dart:async';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      // title: "Student List",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.purple
      ),
      home: NotesList(),
    );
  }

}