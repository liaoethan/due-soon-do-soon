import 'package:flutter/material.dart';
import 'dart:async';
import 'package:duesoonapp/task.dart';
import 'package:duesoonapp/sqflite_db.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TaskAddEdit extends StatefulWidget {

  final String appBarTitle;
  final Task task;

  TaskAddEdit(this.task, this.appBarTitle);

  @override
  State<StatefulWidget> createState()
  {
    return TaskAddEditState(this.task, this.appBarTitle);
  }
}

class TaskAddEditState extends State<TaskAddEdit> {

  SQLDatabase dbh = SQLDatabase();

  String appBarTitle;
  Task task;

  var selectedDate = "Due Date: N/A";

  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TaskAddEditState(this.task, this.appBarTitle);

  static var _prioritiesList = ['Due Now', 'Due Soon', 'Due Later'];

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    taskNameController.text = task.taskName;
    descriptionController.text = task.description;

    return WillPopScope(
        onWillPop: () {
          moveToPreviousScreen();
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: AppBar(
                title: new Center(child: new Text(
                  appBarTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold)
                  ,)
                ),
                leading: IconButton(icon: Icon(
                    Icons.arrow_back_ios),
                    onPressed: () {
                      moveToPreviousScreen();
                    }),
                backgroundColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(35),
                  ),
                ),)
          ),

          body: Padding(
              padding: EdgeInsets.only(top: 80.0, left: 10.0, right: 10.0),
              child: ListView(
                  children: <Widget>[

                    ListTile(
                      title: DropdownButton(
                          items: _prioritiesList.map((String dropDownStringItem) {
                            return DropdownMenuItem<String> (
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem, textAlign: TextAlign.center),
                            );
                          }).toList(),

                          style: textStyle,

                          value: convertNumToPriority(task.priority),

                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              debugPrint('User selected $valueSelectedByUser');
                              convertPriorityToNum(valueSelectedByUser);
                            });
                          }
                      ),
                    ),

                    // Second Element
                    Padding(
                        padding: EdgeInsets.only(top: 80.0, bottom: 15.0),
                        child: TextField(
                            controller: taskNameController,
                            style: textStyle,
                            onChanged: (value) {
                              updateTaskName();
                            },
                            decoration: InputDecoration(
                                labelText: 'Task Name',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)
                                )
                            )
                        )
                    ),

                    // Third Element
                    Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                        child: TextField(
                            controller: descriptionController,
                            style: textStyle,
                            onChanged: (value) {
                              updateDescription();
                            },
                            decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)
                                )
                            )
                        )
                    ),

                    // Fourth Element
                    Padding(
                        padding: EdgeInsets.only(top: 60.0, bottom: 15.0),
                        child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: RaisedButton(
                                      color: Theme.of(context).primaryColorDark,
                                      textColor: Theme.of(context).primaryColorLight,
                                      child: Text(
                                        'Save',
                                        textScaleFactor: 1.5,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _saveElement();
                                        });
                                      }
                                  )
                              ),

                              Container(width: 5.0,),

                              Expanded(
                                  child: RaisedButton(
                                      color: Theme.of(context).primaryColorDark,
                                      textColor: Theme.of(context).primaryColorLight,
                                      child: Text(
                                        'Delete',
                                        textScaleFactor: 1.5,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _deleteElement();
                                        });
                                      }
                                  )
                              )
                            ]
                        )
                    ),


                    // Fifth
                    FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2018, 3, 5),
                              maxTime: DateTime(2019, 6, 7),
                              theme: DatePickerTheme(
                                  headerColor: Colors.orange,
                                  backgroundColor: Colors.blue,
                                  itemStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  doneStyle:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                              onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                              }, onConfirm: (date) {
                                selectedDate = "Due Date: " + date.toString();
                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                        child: Text(
                          'show date picker(custom theme &date time range)',
                          style: TextStyle(color: Colors.blue),
                        )),

                  ]
              )
          ),
        ));
  }

  void convertPriorityToNum(String value) {
    switch (value) {
      case 'Due Now':
        task.priority = 1;
        break;
      case 'Due Soon':
        task.priority = 2;
        break;
      case 'Due Later':
        task.priority = 3;
        break;
      default:
        print("Error in converting prio to nu ");
        break;
    }
  }

  String convertNumToPriority(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _prioritiesList[0];  // 'Due Now'
        break;
      case 2:
        priority = _prioritiesList[1];  // 'Due Soon'
        break;
      case 3:
        priority = _prioritiesList[2];  // 'Due Later'
        break;
      default:
        print("Error in converting num to prio");
        break;
    }
    return priority;
  }

  void updateTaskName(){
    task.taskName = taskNameController.text;
  }

  void updateDescription() {
    task.description = descriptionController.text;
  }

  void moveToPreviousScreen() {
    Navigator.pop(context, true);
  }

  void _saveElement() async {

    moveToPreviousScreen();

    task.date = selectedDate;
    int result;
    if (task.id != null) {
      result = await dbh.updateTask(task);
    } else {
      result = await dbh.addTask(task);
    }
  }

  void _deleteElement() async
  {
    moveToPreviousScreen();
    await dbh.deleteTask(task.id);
  }
}

// Date and Time Custom Picker
class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex())
        : DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex());
  }
}