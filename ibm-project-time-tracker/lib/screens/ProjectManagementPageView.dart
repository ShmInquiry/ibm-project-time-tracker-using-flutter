import 'package:flutter/material.dart';
import '/services/LocalStorage.dart';
import '/models/ProjectVM.dart';

class ProjectManagementPage extends StatefulWidget {
  const ProjectManagementPage({super.key});

  @override
  State<ProjectManagementPage> createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage> {
  List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    projects = await LocalStorageService.loadProjects();
    setState(() {});
  }

  Future<void> _addProject(String name) async {
    projects.add(Project(name));
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
                  key: ValueKey(projects[index].name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteProject(index),
                  child: ListTile(title: Text(projects[index].name)),
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
