class Task {
  final String name;
  Task(this.name);

  Map<String, dynamic> toJson() => {'name': name};
  factory Task.fromJson(Map<String, dynamic> json) => Task(json['name']);
}
