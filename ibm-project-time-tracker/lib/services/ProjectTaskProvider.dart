import 'package:flutter/material.dart';
import '/models/ProjectVM.dart';
import '/services/LocalStorage.dart';
import '/main.dart';

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
                color: lattice80_1_hex,
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
