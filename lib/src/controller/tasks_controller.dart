// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:todocupertino/src/model/task_model.dart';
import 'package:todocupertino/src/repository/task_repository.dart';

class TasksController extends ValueNotifier<TasksState> {
  TasksController() : super(TasksState.initial());
  final TaskRepository _repository = TaskRepository();

  Future<void> getTasks() async {
    value = value.copyWith(isLoading: true);
    List<TaskModel>? tasks = await _repository.getAllTasks();
    value = value.copyWith(isLoading: false, tasks: tasks);
  }

  Future<void> changeStatusTask(int index, bool? newStatus) async {
    value.tasks[index].complete = newStatus ?? value.tasks[index].complete;
    value.tasks.sort((a, b) => a.complete ? 1 : 0);
    await _repository.saveTasks(value.tasks);
    notifyListeners();
  }

  Future<void> deleteTask(int index) async {
    value.tasks.removeAt(index);
    await _repository.saveTasks(value.tasks);
    notifyListeners();
  }

  Future<void> createNewTask(String title, DateTime? dateTime, Function onSuccess) async {
    title.isEmpty
        ? value = value.copyWith(textFieldTitleError: "Required field")
        : value = value.copyWith(textFieldTitleError: "");
    dateTime == null
        ? value = value.copyWith(textFieldDateerror: "Required field")
        : value = value.copyWith(textFieldDateerror: "");
    if (title.isNotEmpty && dateTime != null) {
      TaskModel newTask = TaskModel(title: title, dateTime: dateTime);
      value.tasks.add(newTask);
      await _repository.saveTasks(value.tasks);
      onSuccess();
      notifyListeners();
    }
  }

  Future<void> disposeCreatePage() async {
    value = value.copyWith(textFieldDateerror: "", textFieldTitleError: "", createIsLoading: false);
  }
}

class TasksState extends Equatable {
  final bool isLoading;
  final bool createIsLoading;
  final String textFieldTitleError;
  final String textFieldDateerror;
  final List<TaskModel> tasks;
  const TasksState(
      {required this.isLoading,
      required this.tasks,
      required this.textFieldDateerror,
      required this.createIsLoading,
      required this.textFieldTitleError});
  TasksState.initial(
      {this.isLoading = false,
      this.createIsLoading = false,
      this.textFieldDateerror = "",
      this.textFieldTitleError = ""})
      : tasks = [];

  TasksState copyWith({
    bool? isLoading,
    bool? createIsLoading,
    String? textFieldTitleError,
    String? textFieldDateerror,
    List<TaskModel>? tasks,
  }) {
    return TasksState(
      isLoading: isLoading ?? this.isLoading,
      createIsLoading: createIsLoading ?? this.createIsLoading,
      textFieldTitleError: textFieldTitleError ?? this.textFieldTitleError,
      textFieldDateerror: textFieldDateerror ?? this.textFieldDateerror,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object> get props {
    return [
      isLoading,
      createIsLoading,
      textFieldTitleError,
      textFieldDateerror,
      tasks,
    ];
  }
}
