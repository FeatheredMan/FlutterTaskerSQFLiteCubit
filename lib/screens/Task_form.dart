import 'package:database_cubit/database_sqflite/database_cubit.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:database_cubit/models/task.dart';

class TaskForm extends StatefulWidget {
  TaskForm({Task task});
  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<TaskForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController levelController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  final dateTime = DateTime.now();
  OnSave() {
    if (titleController.text != "") {
      int id;
      // print("id = $id");
      Task insertTask = new Task(id ,titleController.text,
          description: descriptionController.text,
          date: dateTime.format(AmericanDateFormats.dayOfWeek).toString()
          // level:levelController.text , type: typeController.text
          );
      print("One Task module is created");
      DatabaseCubit.get(context).insert(insertTask);
      print("One Task Inserted;");
      reset();
      print("One Task Inserted; all finished");
    } else {
      print("there is no title");
    }
  }

  reset() {
    titleController.text = "";
    descriptionController.text = "";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),

              Text(
                "Create Task",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 42,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w900),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Title :",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.amber,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: ''),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w700),
                      controller: titleController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Title is required';
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Description :",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.amber,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      maxLength: 1000,
                      decoration: InputDecoration(labelText: ''),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w700),
                      controller: descriptionController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),

               FloatingActionButton(
                child: Text("Save"),
                onPressed: OnSave,
                backgroundColor: Colors.amberAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
