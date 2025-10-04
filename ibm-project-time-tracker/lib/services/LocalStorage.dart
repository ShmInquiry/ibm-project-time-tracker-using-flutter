import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '/models/TimeEntryVM.dart';
import '/models/ProjectVM.dart';
import '/models/TaskVM.dart';

class LocalStorageService {
  static const _timeEntriesKey = 'time_entries';
  static const _projectsKey = 'projects';
  static const _tasksKey = 'tasks';

  static Future<void> saveTimeEntries(List<TimeEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_timeEntriesKey, jsonEncode(jsonList));
  }

  static Future<List<TimeEntry>> loadTimeEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_timeEntriesKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => TimeEntry.fromJson(e)).toList();
  }

  // Project
  static Future<void> saveProjects(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = projects.map((p) => p.toJson()).toList();
    await prefs.setString(_projectsKey, jsonEncode(jsonList));
  }

  static Future<List<Project>> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_projectsKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => Project.fromJson(e)).toList();
  }

  // Task
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await prefs.setString(_tasksKey, jsonEncode(jsonList));
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_tasksKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => Task.fromJson(e)).toList();
  }
}
