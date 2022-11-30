import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) async {
    return DBHelper.insert(task);
  }

  getTasks() async {
    var tasks = await DBHelper.query();

    taskList.assignAll(tasks.map((json){
    return  Task(
          id: json['id'],
          title: json['title'],
          note: json['note'],
          isCompleted: json['isCompleted'],
          date: json['date'],
          startTime: json['startTime'],
          endTime: json['endTime'],
          color: json['color'],
          remind: json['remind'],
          repeat: json['repeat']);
    }).toList());
  }

  DeleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  DeleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  markTaskComplete(int id) async {
    await DBHelper.update(id);
    getTasks();
  }


}
