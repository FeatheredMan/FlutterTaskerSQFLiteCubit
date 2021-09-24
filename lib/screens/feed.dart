import 'package:database_cubit/database_sqflite/database_cubit.dart';
import 'package:database_cubit/database_sqflite/database_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:database_cubit/models/task.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  DateTime dateTime = DateTime.now();

  OnUpdate(int id) {
    int enteryid = id;
    if (titleController.text != "") {
      print("id = $id");
      Task updateTask = new Task(enteryid, titleController.text,
          description: descriptionController.text,
          date: dateTime.format(AmericanDateFormats.dayOfWeek).toString());
      print("One Task module is updated");
      DatabaseCubit.get(context).update(updateTask, enteryid);
      print("One Task Updated; all finished");
    } else {
      print("there is no title");
    }
  }

  @override
  void initState() {
    DatabaseCubit get(context) =>
        BlocProvider.of<DatabaseCubit>(context, listen: false);
    DatabaseCubit.get(context).getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshList() async {
      DatabaseCubit.get(context).getTasks();
    }

    return BlocConsumer<DatabaseCubit, DatabaseState>(
      listener: (context, state) {
        print(state);
      },
      builder: (context, state) {
        print(state);
        print(" bloc Consumer works");

        return Flexible(
          child: RefreshIndicator(
            child: FutureBuilder<List<Task>>(
              future: DatabaseCubit.get(context).getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return SizedBox();
                }
                final taskdata = snapshot.data;
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 6,vertical: 4),
                  itemCount: taskdata?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final item = taskdata[index];
                    return Dismissible(
                      key: Key("task"),
                      onDismissed: (direction) {
                        DatabaseCubit.get(context).delete(item.id);
                        setState(() {
                          taskdata.removeAt(item.id);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$item dismissed')));
                      },
                      background: Container(color: Colors.red),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        selectedTileColor: Colors.amberAccent,
                        tileColor: Colors.pink,
                        title: Text(taskdata[index].title,style :TextStyle(fontSize: 22,
                            color: Colors.amber ,fontWeight:FontWeight.w600),),
                        subtitle: Column(mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text(taskdata[index].description, style:
                            TextStyle(fontSize: 18,color: Colors.white ,fontWeight:
                            FontWeight.w600),),
                            SizedBox(height: 5),
                            Text(taskdata[index].date ,style :TextStyle(fontSize: 14,
                                color: Colors.indigo ,fontWeight:FontWeight.w400),),
                          ],
                        ),
                        onLongPress: () {
                          titleController.text = item.title;
                          descriptionController.text = item.description;
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                SingleChildScrollView(
                              child: AlertDialog(
                                title: const Text("What's new"),
                                content: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Title :",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.amber,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                labelText: "Title"),
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
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Description :",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.amber,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 8,
                                            maxLength: 1000,
                                            decoration: InputDecoration(
                                                labelText: "description"),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.w700),
                                            controller: descriptionController,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 2),

                                    //there is two raised button need {Style}
                                    Row(
                                      children: [
                                        RaisedButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text('Update'),
                                          onPressed: () {
                                            OnUpdate(item.id);
                                            Navigator.pop(context, 'OK');
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.deepOrange,
                    );
                  },
                );
              },
            ),
            onRefresh: _refreshList,
          ),
        );
      },
    );
  }
}
