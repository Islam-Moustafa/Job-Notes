import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:jobnote/models/notes.dart';
import 'package:jobnote/utilities/sql_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jobnote/Screen/notes_list.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

class NotesDetail extends StatefulWidget {

  // title of page when add or update
  String screenTitle;
  Notes student;

  NotesDetail(this.student, this.screenTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotesDetailState(this.student, screenTitle);
  }
}

class NotesDetailState extends State<NotesDetail>{

  static var _status = ["Not Important","Important"];
  // title of page when add or update
  String screenTitle;
  Notes notes;
  SQL_Helper helper = new SQL_Helper();

  NotesDetailState(this.notes, this.screenTitle);

  TextEditingController headline = new TextEditingController();
  TextEditingController details = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    // put from database into TextField
    headline.text = notes.name;
    details.text = notes.description;

    // TODO: implement build
    return
    // use willPopScope to control in back button in navigation bar
      WillPopScope(
        onWillPop: (){
          debugPrint("WillPopScope button");
          getBack();
        },

      child: Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            getBack();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child:    ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _status.map((String dropDownItem){
                  return DropdownMenuItem<String>(
                    value: dropDownItem,
                    child: Text(dropDownItem),
    );
                }).toList(),
                style: textStyle,
                value: getPassing(notes.pass),
                onChanged: (selectedItem){
                  setState(() {
                    // debugPrint("User Select $selectedItem");
                    setPassing(selectedItem);
                  });
                },
              ),
            ),

              // first TextField
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: headline,
                  style: textStyle,
                  onChanged: (value){
                    // debugPrint("User Edit The Name");
                    notes.name = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Headline: ",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                  ),
                ),
              ),

            // second button
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: details,
                style: textStyle,
                onChanged: (value){
                  // debugPrint("User Edit The Description");
                  notes.description = value;
                },
                decoration: InputDecoration(
                    labelText: "Details: ",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                          "SAVE", textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          debugPrint("User Click SAVED");
                          _save();
                        });
                      },
                    ),
                  ),

                  Container(width: 5.0,),

                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        "DELETE", textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          debugPrint("User Click DELETE");
                          _delete();
                        });
                      },
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    )
      );
  }

  // to back button in appBar or in navigation bar
  void getBack(){
    Navigator.pop(context, true);
  }

  // convert priority from String to integer
  void setPassing(String value){
    switch(value){
      case "Not Important":
        notes.pass = 1;
        break;
      case "Important":
        notes.pass = 2;
        break;
    }
  }

  // convert pass from integer to String
  String getPassing(int value){
    String pass;
    switch(value){
      case 1:
        pass = _status[0];
        break;
      case 2:
        pass = _status[1];
        break;
    }
    return pass;
  }


  // implementation save button
  void _save() async {
    // back to list after save
    getBack();

    // time now
    notes.date = DateFormat.yMMMd().format(DateTime.now()) + "   " +
        DateFormat.Hm().format(DateTime.now());
    // var t = TimeOfDayFormat.H_colon_mm;

    int result;
    if(notes.id == null){
      result = await helper.insertStudent(notes);
    }else{
      result = await helper.updateStudent(notes);
    }

    if(result == 0){
      showAlertDialog('Sorry', 'Note not save');
    }else{
      showAlertDialog('Congratulation', 'Note has been saved successfuly');
    }
  }

  // showAlertDialog when save
  void showAlertDialog(String title, String msg){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }


  void _delete() async {
    getBack();
    if(notes.id == null){
      showAlertDialog('Ok Delete', "No Note was deleted");
      return;
    }
    int result = await helper.deleteNotes(notes.id);
    if(result == 0){
      showAlertDialog('Ok Delete', "No Note was deleted");
    }else{
      showAlertDialog('Ok Delete', "Note has been deleted");
    }
  }


}
