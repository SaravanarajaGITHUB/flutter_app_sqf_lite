class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  //constructor
  Note(this._title, this._date, this._priority, [this._description]);

  //named constructor
  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  //getter's
  int get priority => _priority;

  String get date => _date;

  String get description => _description;

  String get title => _title;

  int get id => _id;

  //setter's
  set title(String value) {
    if (value.length <= 255) {
      _title = value;
    }
  }

  set priority(int value) {
    if (value == 1 || value == 2) {
      _priority = value;
    }
  }

  set description(String value) {
    if (value.length <= 255) {
      _description = value;
    }
  }

  set date(String value) {
    _date = value;
  }

  //convert note object to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = this._id;
    }
    map['title'] = this._title;
    map['description'] = this._description;
    map['priority'] = this._priority;
    map['date'] = this._date;

    return map;
  }

  //extract note object from map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}
