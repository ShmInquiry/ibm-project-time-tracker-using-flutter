import 'package:flutter/material.dart';
import '/models/TimeEntryVM.dart';
import '/widgets/AddProjectDialogWidget.dart';
import '/LocalStorage.dart';
import '/widgets/ProjectandTasksTabBar.dart';

class ProjectManagementPage extends StatefulWidget {
  const ProjectManagementPage({super.key});

  @override
  State<ProjectManagementPage> createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage> {
  List<String> projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final data = await LocalStorageService.loadProjects();
    setState(() => projects = data);
  }

  Future<void> _addProject(String name) async {
    projects.add(name);
    await LocalStorageService.saveProjects(projects);
    _loadProjects();
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Project'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _addProject(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProject(int index) async {
    projects.removeAt(index);
    await LocalStorageService.saveProjects(projects);
    _loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Projects')),
      body: projects.isEmpty
          ? const Center(child: Text('No projects added.'))
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(projects[index]),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteProject(index),
                  child: ListTile(title: Text(projects[index])),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskManagementPage extends StatefulWidget {
  const TaskManagementPage({super.key});

  @override
  State<TaskManagementPage> createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {
  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final list = await LocalStorageService.loadTasks();
    setState(() => tasks = list);
  }

  Future<void> _addTask(String task) async {
    tasks.add(task);
    await LocalStorageService.saveTasks(tasks);
    setState(() {});
  }

  void _showAddTaskDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Task name')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addTask(controller.text);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Tasks')),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks added yet.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) => ListTile(title: Text(tasks[i])),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
