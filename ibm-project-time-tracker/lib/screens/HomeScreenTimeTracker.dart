import 'package:flutter/material.dart';
import '/models/TimeEntryVM.dart';
import '/widgets/ProjectandTasksTabBar.dart';
import '/LocalStorage.dart';
import 'ProjectManagementPageView.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TimeEntry> timeEntries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await LocalStorageService.loadTimeEntries();
    setState(() => timeEntries = entries);
  }

  void _deleteEntry(String project, int index) async {
    setState(() {
      final entries = timeEntries.where((e) => e.project == project).toList();
      final target = entries[index];
      timeEntries.remove(target);
    });
    await LocalStorageService.saveTimeEntries(timeEntries);
  }

  Map<String, List<TimeEntry>> groupByProject(List<TimeEntry> entries) {
    final Map<String, List<TimeEntry>> grouped = {};
    for (var entry in entries) {
      grouped.putIfAbsent(entry.project, () => []);
      grouped[entry.project]!.add(entry);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedEntries = groupByProject(timeEntries);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(child: Text('Time Tracker')),
              ListTile(
                title: const Text('Projects'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProjectManagementPage()),
                ),
              ),
              ListTile(
                title: const Text('Tasks'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskManagementPage()),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Time Tracker'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Projects'),
              Tab(text: 'Tasks'),
            ],
          ),
        ),
        body: timeEntries.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('No time entries yet.',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : TabBarView(
                children: [
                  ProjectsTab(
                      groupedEntries: groupedEntries, onDelete: _deleteEntry),
                  TasksTab(timeEntries: timeEntries),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTimeEntryScreen()),
            );
            _loadEntries();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// Temporary placeholder until you implement Task Management Page
class TaskManagementPage extends StatelessWidget {
  const TaskManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Tasks')),
      body: const Center(child: Text('Tasks management coming soon...')),
    );
  }
}
