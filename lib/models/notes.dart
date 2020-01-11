class Notes {

  //members
  int _id;
  String _name;
  String _description;
  int _pass;
  String _date;

  // constructor without id
  Notes(this._name, this._description, this._pass, this._date);

  Notes.withId(this._id, this._name, this._description, this._pass,
      this._date);

  // getter methods
  String get date => _date;

  int get pass => _pass;

  String get description => _description;

  String get name => _name;

  int get id => _id;


  // setter methods
  set date(String value) {
    _date = value;
  }

  set pass(int value) {
    // validation .. if 1 is success and if 2 is failed
    if(value >= 1 && value <= 2 ) {
      _pass = value;
    }
  }

  set description(String value) {
    // validation
    if(value.length <= 255){
    _description = value;
  }
}

  set name(String value) {
    // validation
    if (value.length <= 255) {
      _name = value;
    }
  }

  // sqflite deal with map to put data into database or retrieve data from database
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["id"] = this._id;
    map["name"] = this._name;
    map["description"] = this._description;
    map["pass"] = this._pass;
    map["date"] = this._date;
    return map;
  }

  Notes.getMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._name = map["name"];
    this._description = map["description"];
    this._pass = map["pass"];
    this._date = map["date"];
  }

}
