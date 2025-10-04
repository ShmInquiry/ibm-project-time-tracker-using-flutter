import 'package:flutter/material.dart';
import '/models/TimeEntryVM.dart';
import '/LocalStorage.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProject;
  String? _selectedTask;
  String _totalTime = '';
  String _notes = '';
  DateTime _selectedDate = DateTime.now();

  List<String> _projects = [];
  List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    final projects = await LocalStorageService.loadProjects();
    final tasks = await LocalStorageService.loadTasks();
    setState(() {
      _projects = projects;
      _tasks = tasks;
    });
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      final entry = TimeEntry(
        _selectedProject ?? 'Unknown Project',
        _selectedTask ?? 'Unknown Task',
        _totalTime,
        _notes,
        _selectedDate,
      );

      final entries = await LocalStorageService.loadTimeEntries();
      entries.add(entry);
      await LocalStorageService.saveTimeEntries(entries);

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Total Time (e.g. 2h 30m)'),
                onChanged: (val) => _totalTime = val,
                validator: (val) => val!.isEmpty ? 'Enter total time' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Project'),
                items: _projects
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedProject = val),
                value: _selectedProject,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Task'),
                items: _tasks
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTask = val),
                value: _selectedTask,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes'),
                onChanged: (val) => _notes = val,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Text(
                    'Select Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
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

class AddProjectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Project'),
      content: TextField(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
