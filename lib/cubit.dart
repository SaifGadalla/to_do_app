import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/states.dart';
import 'package:to_do_app/tasks_screen.dart';
import 'archived_screen.dart';
import 'done_screen.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isBottomSheetShown = true;
  IconData fapIcon = Icons.edit;

  var database;
  List<Map> tasks =[];

  int currentIndex = 0;

  static init(){

  }

  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  void changeIndex (int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDataBase() {
    database = openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('db created');
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,Date TEXT,time TEXT,status TEXT)'
        ).then((value) {
            print('table created');
          },
        ).catchError((error) {
          print('creating table error ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database).then((value) {
          tasks = value;
          emit(AppGetFromDataBaseState());
        });
        print('db open');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
        txn.rawInsert('INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","")').then((value) {
          print('$value insert success');
          emit(AppInsertToDataBaseState());

          getDataFromDataBase(database).then((value) {
            tasks = value;
            emit(AppGetFromDataBaseState());
          });
        }
        ).catchError((error) {
          print('inserting new raw error ${error.toString()}');
        });
      },
    );
  }

  Future<List<Map>> getDataFromDataBase(database) async {
    emit(AppGetFromDataBaseLoadingState());
    return await database!.rawQuery('SELECT * FROM tasks');
  }

  void changeBottomSheet({
    required isShown,
    required IconData icon
  }){
    isBottomSheetShown=isShown;
    fapIcon = icon;
    emit(AppChangeBottomSheetState());
  }

}