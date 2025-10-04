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

class Project {
  final String name;
  Project(this.name);

  Map<String, dynamic> toJson() => {'name': name};
  factory Project.fromJson(Map<String, dynamic> json) => Project(json['name']);
}
