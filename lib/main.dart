import 'package:database_cubit/database_sqflite/database_cubit.dart';
import 'package:database_cubit/database_sqflite/database_state.dart';
import 'package:database_cubit/screens/Task_form.dart';
import 'package:database_cubit/screens/feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyNote());

/// This is the main application widget.
class MyNote extends StatelessWidget {
  static const String _title = 'notes for all';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    TaskForm(),
    Feed(),
    // Text(
    //   'Index 2: School',
    //   style: optionStyle,
    // ),
    // Text(
    //   'Index 3: Settings',
    //   style: optionStyle,
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: _selectedIndex == 0 ? Colors.redAccent : Colors.pink,
        title: const Text(
          'Your digital memory',
        ),
      ),
      body: BlocProvider(
        create: (BuildContext context) => DatabaseCubit(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _widgetOptions.elementAt(_selectedIndex),
            Container(
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'Home',
                    backgroundColor: Colors.pink,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_to_queue_rounded),
                    label: 'Business',
                    backgroundColor: Colors.pink,
                  ),
                  // BottomNavigationBarItem(
                  // icon: Icon(Icons.school),
                  // label: 'School',
                  // backgroundColor: Colors.purple,
                  // ),
                  // BottomNavigationBarItem(
                  // icon: Icon(Icons.settings),
                  // label: 'Settings',
                  // backgroundColor: Colors.pink,
                  // ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
