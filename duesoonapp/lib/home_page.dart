import 'package:flutter/material.dart';
import 'package:duesoonapp/task_addEdit_page.dart';
import 'dart:async';
import 'package:duesoonapp/task.dart';
import 'package:duesoonapp/sqflite_db.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

  SQLDatabase databaseHelper = SQLDatabase();
  List<Task> taskList;
  int numEntries = 0;

  @override
  Widget build(BuildContext context) {

    if (taskList == null) {
      taskList = List<Task>();
      updateListView();
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: AppBar(
            title: new Center(child: new Text("\n\n-      D U E     S O O N     -  \n", textAlign: TextAlign.center, style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),)),
            backgroundColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(35),
              ),
            ),)
      ),
      body: getNoteListView(),

      floatingActionButton: FloatingActionButton (
        onPressed: () {
          debugPrint('FAB clicked');
          switchAddEditPage(Task('','',2), "\n\nA D D    T A S K       +\n");
        },

        tooltip: 'Add Note',

        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {

    return ListView.builder(
      itemCount: numEntries,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          margin: EdgeInsets.all(18.0),
          color: Colors.red,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2.0,
          child: ListTile(

            title: new Center( child: Text(this.taskList[position].taskName, style: new TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20.0),)),

            subtitle: new Center( child: Text(this.taskList[position].date, style: new TextStyle(
                fontWeight: FontWeight.w500, fontSize: 17.0, color: Colors.grey),)),

            trailing: GestureDetector(
              child: Icon(Icons.check_circle_outline, color: Colors.green,),
              onTap: () {
                _delete(context, taskList[position]);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              switchAddEditPage(this.taskList[position],'Edit Note');
            },

          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.green;
    }
  }

  void _delete(BuildContext context, Task note) async {

    int result = await databaseHelper.deleteTask(note.id);
    if (result != 0) {
      _successBar(context, 'Task Completed!');
      updateListView();
    }
  }

  void _successBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void switchAddEditPage(Task note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TaskAddEdit(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Task>> noteListFuture = databaseHelper.getTaskList();
      noteListFuture.then((noteList) {
        setState(() {
          this.taskList = noteList;
          this.numEntries = noteList.length;
        });
      });
    });
  }
}