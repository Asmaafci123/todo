import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/tasks/new_tasks.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Map>newTasks = [];
  List<Map>doneTasks = [];
  List<Map>archivedTasks = [];

  Database? database;
  bool isBottomSheetShown = false;
  IconData toggleIcon = Icons.edit;
  List<Widget> Screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> Titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavigationBarState());
  }

  void createDataBase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) async {
          await database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
              .then((value) {
            //  database=value;
            emit(AppCreateDataBaseState());
          }).catchError((error) {
            print(error.toString());
          });
        },
        onOpen: (database) {
          getDataFromDataBase(database);
        });
  }

  insertDataBase({required String title,
    required String date,
    required String time}) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO tasks (title,date,time,status)VALUES("$title","$date","$time","new")')
          .then((value) {
        print('insert Success');
        emit(AppInsertDataBaseState());
        getDataFromDataBase(database!);
      })
          .catchError((error) => print('catch error ${error.toString()}'));
      return null;
    });
  }

  void getDataFromDataBase(Database database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        print(element);
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      }
      emit(AppGetDataBaseState());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    toggleIcon = icon;
    emit(AppBottomSheetState());
  }

   void update({required String status, required int id}) async{
    await database?.rawUpdate('UPDATE tasks SET status=? WHERE id=?',
         [status,id]).
     then((value){
       getDataFromDataBase(database!);
       emit(AppUpdateDataBaseState());
    });
   }


  void delete({required int id})async{
    database?.rawDelete('DELETE FROM tasks WHERE id=?',
        [id]).
    then((value){
      getDataFromDataBase(database!);
      emit(AppDeleteDataBaseState());
    });
  }
}