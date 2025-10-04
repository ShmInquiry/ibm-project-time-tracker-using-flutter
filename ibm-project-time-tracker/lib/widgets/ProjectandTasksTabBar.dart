import 'package:flutter/material.dart';
import '/services/TimeEntryProvider.dart';
import '/models/ProjectVM.dart';

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
