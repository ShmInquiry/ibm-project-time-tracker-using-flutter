import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '/models/TimeEntryVM.dart';

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

  static Future<void> saveList(String key, List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, list);
  }

  static Future<List<String>> loadList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<List<String>> loadProjects() async => loadList(_projectsKey);

  static Future<List<String>> loadTasks() async => loadList(_tasksKey);

  static Future<void> saveProjects(List<String> list) async =>
      saveList(_projectsKey, list);

  static Future<void> saveTasks(List<String> list) async =>
      saveList(_tasksKey, list);
}
