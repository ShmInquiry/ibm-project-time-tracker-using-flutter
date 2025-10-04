import 'package:flutter/material.dart';
import '/services/LocalStorage.dart';
import '/models/TimeEntryVM.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  Future<void> loadEntries() async {
    _entries = await LocalStorageService.loadTimeEntries();
    notifyListeners();
  }

  Future<void> addEntry(TimeEntry entry) async {
    _entries.add(entry);
    await LocalStorageService.saveTimeEntries(_entries);
    notifyListeners();
  }

  Future<void> deleteEntry(TimeEntry entry) async {
    _entries.remove(entry);
    await LocalStorageService.saveTimeEntries(_entries);
    notifyListeners();
  }
}
