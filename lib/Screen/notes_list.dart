import 'package:flutter/material.dart';
import 'package:jobnote/Screen/notes_detail.dart';
import 'dart:async';
import 'package:jobnote/models/notes.dart';
import 'package:jobnote/utilities/sql_helper.dart';
import 'package:sqflite/sqflite.dart';


class NotesList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotesState();
  }
}

class NotesState extends State<NotesList>{
  SQL_Helper helper = new SQL_Helper();
  List<Notes> notesList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(notesList == null){
      notesList = new List<Notes>();
      updateListView();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Notes"),
      ),
      body: getStudentsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // debugPrint("floating has been checked");
         navigateToNotesDetail(Notes('', '', 1, ''), "Add");
        },
        tooltip: "Add",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getStudentsList(){
    return ListView.builder(
      itemCount: count,
        itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: ispassed(this.notesList[position].pass),
              // child: getIcon(this.studentList[position].pass),
              child: Text((position+1).toString()),
            ),
            title: Text(this.notesList[position].name,),
            subtitle: Text(
                this.notesList[position].date ),

            trailing:
            GestureDetector(
            child: Icon(Icons.delete, color: Colors.grey),
            onTap: (){
              _delete(context, this.notesList[position]);
              updateListView();
            },
            ),

            onTap: (){
              // debugPrint("student tabed");
              navigateToNotesDetail(this.notesList[position], "Edit");
            },
          ),
        );
        }
    );
  }

  void navigateToNotesDetail(Notes notes, String appTitle)async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NotesDetail(notes, appTitle);
    }));
    if(result){
      updateListView();
    }
  }

  Color ispassed (int value){
    switch(value){
      case 1:
        return Colors.purple;
        break;
      case 2:
        return Colors.redAccent;
        break;
      default:
        return Colors.purple;
    }
  }

  Icon getIcon(int value){
    switch(value){
      case 1:
        return Icon(Icons.check);
        break;
      case 2:
        return Icon(Icons.close);
        break;
      default:
        return Icon(Icons.check);
    }
  }

  void _delete(BuildContext context, Notes student) async {
    int result = await helper.deleteNotes(student.id);
    if(result != 0 ){
      _showSnackBar(context, "Note has been deleted");
      // update listView
    }
  }

  void updateListView(){
    final Future<Database> db = helper.initalizeDataBase();
    db.then((database){
      Future<List<Notes>> notes = helper.getStudentList();
      notes.then((theList){
        setState(() {
          this.notesList = theList;
          this.count = theList.length;
        });
      });
    });
  }

  void _showSnackBar(BuildContext context, String msg){
    final snackBar = SnackBar(content: Text(msg),);
    Scaffold.of(context).showSnackBar(snackBar);
  }


}