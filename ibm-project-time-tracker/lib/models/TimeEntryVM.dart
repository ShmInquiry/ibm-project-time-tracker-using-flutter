import 'package:flutter/material.dart';
import '/LocalStorage.dart';

class TimeEntry {
  final String project;
  final String task;
  final String totalTime;
  final String notes;
  final DateTime date;

  TimeEntry(this.project, this.task, this.totalTime, this.notes, this.date);

  Map<String, dynamic> toJson() => {
        'project': project,
        'task': task,
        'totalTime': totalTime,
        'notes': notes,
        'date': date.toIso8601String(),
      };

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      json['project'],
      json['task'],
      json['totalTime'],
      json['notes'],
      DateTime.parse(json['date']),
    );
  }
}

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedProject;
  String? selectedTask;
  String totalTime = '';
  String notes = '';

  List<String> projects = [];
  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadDropdowns();
  }

  Future<void> _loadDropdowns() async {
    projects = await LocalStorageService.loadProjects();
    tasks = await LocalStorageService.loadTasks();
    setState(() {});
  }

  Future<void> _saveEntry() async {
    final entries = await LocalStorageService.loadTimeEntries();
    entries.add(TimeEntry(selectedProject ?? '', selectedTask ?? '', totalTime,
        notes, DateTime.now()));
    await LocalStorageService.saveTimeEntries(entries);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Total Time'),
                onChanged: (value) => totalTime = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Project'),
                value: selectedProject,
                onChanged: (value) => setState(() => selectedProject = value),
                items: projects
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Task'),
                value: selectedTask,
                onChanged: (value) => setState(() => selectedTask = value),
                items: tasks
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes'),
                onChanged: (value) => notes = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
