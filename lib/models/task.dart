import 'package:database_cubit/database_sqflite/database_cubit.dart';

class Task {
  int id;
  String title;
  String description;
  String date;

  Task(id ,this.title, {this.description, this.date});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      // DatabaseCubit.COLUMN_ID: id,
      DatabaseCubit.COLUMN_TITLE: title,
      DatabaseCubit.COLUMN_DESCRIPTION: description,
      DatabaseCubit.COLUMN_DATE: date,
    };
       return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseCubit.COLUMN_ID];
    title = map[DatabaseCubit.COLUMN_TITLE];
    description = map[DatabaseCubit.COLUMN_DESCRIPTION];
    date = map[DatabaseCubit.COLUMN_DATE];
  }
}
