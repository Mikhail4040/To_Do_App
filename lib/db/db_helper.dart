import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';

class DBHelper {
  static Database? db;
  static int version = 3;
  static String tableName = "tasks";

  static Future<void> initDb() async {
    if (db != null) {
      print("Not null DataBase");
      return;
    } else {
      try {
        String path = await getDatabasesPath() + 'task.db';
        db = await openDatabase(path, version: version,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE $tableName ('
                  'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                  'title STRING , note TEXT , date STRING,'
                  'startTime STRING , endTime STRING,'
                  'remind INTEGER , repeat STRING , color INTEGER , isCompleted INTEGER)'
          );
        });
      } catch (e) {
        print(e);
      }
    }
  }

 static  Future<int> insert(Task? task)async{ // تعيد id
    print("insert someThing");
    return await db!.insert(tableName, task!.toJson());    //بضيف البيانات ك ماب
  }


  static  Future<int> delete(Task? task)async{
    print("delete someThing");
    return await db!.delete(tableName,where: 'id=?',whereArgs: [task!.id]);
  }


  static  Future<int> deleteAll()async{
    print("delete someThing");
    return await db!.delete(tableName);
  }


  static  Future<int> update(int id)async{
    print("update someThing");
    return await db!.rawUpdate(''' 
    UPDATE tasks 
    SET isCompleted = ?
    WHERE id = ?
    ''',[1,id]);     // كل برمتر بينزل محل اشارة استفهام
  }


  static  Future<List<Map<String, dynamic>>> query()async{
    print("query something");
    return await db!.query(tableName);
  }





}
