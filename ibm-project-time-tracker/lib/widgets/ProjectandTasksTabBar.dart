import 'package:flutter/material.dart';
import '/models/TimeEntryVM.dart';

class TasksTab extends StatelessWidget {
  final List<TimeEntry> timeEntries;

  const TasksTab({super.key, required this.timeEntries});

  @override
  Widget build(BuildContext context) {
    if (timeEntries.isEmpty) {
      return const Center(child: Text('No tasks logged yet.'));
    }

    final groupedByTask = <String, List<TimeEntry>>{};
    for (var entry in timeEntries) {
      groupedByTask.putIfAbsent(entry.task, () => []);
      groupedByTask[entry.task]!.add(entry);
    }

    return ListView(
      children: groupedByTask.entries.map((e) {
        return ExpansionTile(
          title: Text(e.key),
          children: e.value.map((t) {
            return ListTile(
              title: Text('${t.project} - ${t.totalTime}'),
              subtitle: Text(t.notes),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class ProjectsTab extends StatelessWidget {
  final Map<String, List<TimeEntry>> groupedEntries;
  final void Function(String, int) onDelete;

  const ProjectsTab({
    super.key,
    required this.groupedEntries,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (groupedEntries.isEmpty) {
      return const Center(child: Text('No projects logged yet.'));
    }
    return ListView(
      children: groupedEntries.entries.map((e) {
        return ExpansionTile(
          title: Text(e.key),
          children: e.value.asMap().entries.map((entry) {
            final idx = entry.key;
            final t = entry.value;
            return ListTile(
              title: Text('${t.task} - ${t.totalTime}'),
              subtitle: Text(t.notes),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(e.key, idx),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
