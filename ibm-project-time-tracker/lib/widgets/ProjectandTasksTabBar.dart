import 'package:flutter/material.dart';
import '/models/TimeEntryVM.dart';
import '/LocalStorage.dart';

// class ProjectsTab extends StatelessWidget {
//   final List<String> timeEntries;

//   ProjectsTab({required this.timeEntries});

//   @override
//   Widget build(BuildContext context) {
//     return timeEntries.isEmpty
//         ? Center(child: Text('No time entries yet!'))
//         : ListView.builder(
//             itemCount: timeEntries.length,
//             itemBuilder: (context, index) {
//               return ListTile(title: Text(timeEntries[index]));
//             },
//           );
//   }
// }

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
  final Function(String, int) onDelete; // project + index

  const ProjectsTab({
    required this.groupedEntries,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final projects = groupedEntries.keys.toList();

    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, projIndex) {
        final project = projects[projIndex];
        final entries = groupedEntries[project]!;

        return ExpansionTile(
          title: Text(project),
          children: entries.asMap().entries.map((entry) {
            final idx = entry.key;
            final data = entry.value;

            return Dismissible(
              key: ValueKey('${project}_$idx'),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              dismissThresholds: const {
                DismissDirection.endToStart: 0.35,
              },

              onDismissed: (_) async {
                final deleted = data;
                onDelete(project, idx);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted "${deleted.task}"'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () async {
                        final entries =
                            await LocalStorageService.loadTimeEntries();
                        entries.add(deleted);
                        await LocalStorageService.saveTimeEntries(entries);
                      },
                    ),
                  ),
                );
              },
              // Pass project + entry index
              child: ListTile(
                title: Text(data.task),
                subtitle: Text('${data.totalTime} - ${data.notes}'),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
