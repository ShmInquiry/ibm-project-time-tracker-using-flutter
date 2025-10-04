import 'package:flutter/material.dart';
import '/models/ProjectVM.dart';
import '/models/TaskVM.dart';
import 'LocalStorage.dart';

class ProjectTaskProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  Future<void> loadProjects() async {
    _projects = await LocalStorageService.loadProjects();
    notifyListeners();
  }

  Future<void> addProject(Project project) async {
    if (_projects.any((p) => p.name == project.name))
      return; // prevent duplicates
    _projects.add(project);
    await LocalStorageService.saveProjects(_projects);
    notifyListeners();
  }

  Future<void> deleteProject(Project project) async {
    _projects.removeWhere((p) => p.name == project.name);
    await LocalStorageService.saveProjects(_projects);
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _tasks = await LocalStorageService.loadTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    if (_tasks.any((t) => t.name == task.name)) return; // prevent duplicates
    _tasks.add(task);
    await LocalStorageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    _tasks.removeWhere((t) => t.name == task.name);
    await LocalStorageService.saveTasks(_tasks);
    notifyListeners();
  }
}
