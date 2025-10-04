class Project {
  final String name;
  Project(this.name);

  Map<String, dynamic> toJson() => {'name': name};
  factory Project.fromJson(Map<String, dynamic> json) => Project(json['name']);
}
