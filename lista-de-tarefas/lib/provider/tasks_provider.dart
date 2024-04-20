import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  List<String> _tasks = [];

  List<String> get tasks => _tasks;

  set tasks(List<String> value) {
    _tasks = value;
    notifyListeners();
  }

  void addTask(String task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(int index, String newTask) {
    _tasks[index] = newTask;
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}
