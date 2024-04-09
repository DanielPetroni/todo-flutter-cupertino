import 'package:shared_preferences/shared_preferences.dart';
import 'package:todocupertino/src/model/task_model.dart';

class TaskRepository {
  SharedPreferences? localStorage;
  TaskRepository();

  Future<List<TaskModel>?> getAllTasks() async {
    localStorage ??= await SharedPreferences.getInstance();
    List<String>? tasksString = localStorage?.getStringList('tasks');
    List<TaskModel>? tasks = tasksString?.map((e) => TaskModel.fromJson(e)).toList();
    return tasks;
  }

  Future<bool?> saveTasks(List<TaskModel> tasks) async {
    localStorage ??= await SharedPreferences.getInstance();
    List<String> tasksString = tasks.map((e) => e.toJson()).toList();
    return await localStorage?.setStringList('tasks', tasksString);
  }
}
