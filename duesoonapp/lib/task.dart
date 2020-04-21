
class Task {

  int _id;
  String _taskName;
  String _taskDesc;
  String _date;
  int _priority;

  Task(this._taskName, this._date, this._priority, [this._taskDesc]);

  Task.withId(this._id, this._taskName, this._date, this._priority, [this._taskDesc]);

  int get id => _id;
  String get taskName => _taskName;

  String get description => _taskDesc;
  int get priority => _priority;
  String get date => _date;

  set taskName(String newName) {
      this._taskName = newName; // do input validation!
  }

  set priority(int input) {
    if (input >= 1 && input <= 3) {
      this._priority = input;
    }
  }

  set description(String input) {
      this._taskDesc = input; // do input validation!
  }

  set date(String newDate) {
    this._date = newDate;
  }

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }

    map['id'] = _id;
    map['title'] = _taskName;
    map['description'] = description;
    map['priority'] = priority;
    map['date'] = _date;

    return map;
  }

  // Use for SQFlite Object
  Task.fromMapObject(Map<String,dynamic> map) {
    this._id = map['id'];
    this._taskName = map['title'];
    this._taskDesc = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}