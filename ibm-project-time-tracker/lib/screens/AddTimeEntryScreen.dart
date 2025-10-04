import 'package:flutter/material.dart';
import '/models/TimeEntryVM.dart';
import '/services/LocalStorage.dart';
import '/models/ProjectVM.dart';
import '/models/TaskVM.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  Project? selectedProject;
  Task? selectedTask;
  String totalTime = '';
  String notes = '';

  List<Project> projects = [];
  List<Task> tasks = [];

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
    entries.add(TimeEntry(
      selectedProject?.name ?? '',
      selectedTask?.name ?? '',
      totalTime,
      notes,
      DateTime.now(),
    ));
    await LocalStorageService.saveTimeEntries(entries);
    if (mounted) Navigator.pop(context);
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
              DropdownButtonFormField<Project>(
                decoration: const InputDecoration(labelText: 'Select Project'),
                value: selectedProject,
                onChanged: (value) => setState(() => selectedProject = value),
                items: projects
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                    .toList(),
              ),
              DropdownButtonFormField<Task>(
                decoration: const InputDecoration(labelText: 'Select Task'),
                value: selectedTask,
                onChanged: (value) => setState(() => selectedTask = value),
                items: tasks
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
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
