enum Priority { low, medium, high }

class Task {
  String title;
  bool isDone;
  Priority priority;

  Task({required this.title, this.isDone = false, this.priority = Priority.medium});

  Map<String, dynamic> toJson() => {
    'title': title,
    'isDone': isDone,
    'priority': priority.index,
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isDone: json['isDone'],
      priority: Priority.values[json['priority']],
    );
  }
}
