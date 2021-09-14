import 'package:database_cubit/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:database_cubit/database_sqflite/database_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseInitialState());

  //take object-
  static DatabaseCubit get(context) => BlocProvider.of(context);
  static const String TABLE_task = "task";
  static const String COLUMN_ID = "id";
  static const String COLUMN_TITLE = "title";
  static const String COLUMN_DESCRIPTION = "description";
  static const String COLUMN_DATE = "date";
  Database _database;

  Future<Database> get database async {
    print("database getter called");
//affected by task class task.dart directory:model
    if (_database != null) {
      print('opening previous sqflite database');
      return _database;
    }
    _database = await createDatabase();
    print("created  database sqflite");
    return _database;
  }


  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'taskDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating task table");
        await database.execute("CREATE TABLE $TABLE_task ("
            "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
            "$COLUMN_TITLE TEXT,"
            "$COLUMN_DESCRIPTION TEXT,"
            "$COLUMN_DATE TEXT"
            ");");
        emit(DatabaseInitialState());
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    var tasks = await db.query(TABLE_task, columns: [
      COLUMN_ID,
      COLUMN_TITLE,
      COLUMN_DESCRIPTION,
      COLUMN_DATE,
    ]);
    // if (tasks.isEmpty) return [];
    print(tasks);
    List<Task> taskList = List<Task>();
    tasks.forEach((currenttask) {
      Task task = Task.fromMap(currenttask);
      taskList.add(task);
    });
    print(taskList);
    // emit(DatabaseGetState());
    return taskList;
  }



  insert(Task task) async {
    final db = await database;
    final i = await db.insert(TABLE_task, task.toMap());
    emit(DatabaseAddState());
    return i;
  }



  Future<int> delete(int id) async {
    final db = await database;
    final d = await db.delete(
      TABLE_task,
      where: "id = ?",
      whereArgs: [id],
    );
    print("One Item deleted");
    emit(DatabaseDeleteState());
    return d;
  }



  Future<int> update(Task task, int id) async {
    print('============= $id');
    final db = await database;
    final u = await db.update(
      TABLE_task,
      task.toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
    emit(DatabaseUpdateState());
    return u;
  }
}
