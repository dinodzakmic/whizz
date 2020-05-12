class TaskModel {
  //PROPERTIES
  int id;
  String title;
  DateTime date;
  String priority;
  bool completed;

  //CONSTRUCTORS
  TaskModel({this.title, this.date, this.priority, this.completed});
  TaskModel.withId(
      {this.id, this.title, this.date, this.priority, this.completed});

  //METHODS
  TaskModel copyWith(
      {int id, String title, DateTime date, String priority, bool completed}) {
    return TaskModel.withId(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
        priority: priority ?? this.priority,
        completed: completed ?? this.completed);
  }

  Map<String, dynamic> toJsonMap() {
    final Map<String, dynamic> jsonMap = Map<String, dynamic>();

    if (id != null) {
      jsonMap['id'] = this.id;
    }
    jsonMap['title'] = this.title;
    jsonMap['date'] = this.date.toIso8601String();
    jsonMap['priority'] = this.priority;
    jsonMap['completed'] = this.completed;

    return jsonMap;
  }

  factory TaskModel.fromJsonMap(Map<String, dynamic> jsonMap) {
    return TaskModel.withId(
        id: jsonMap['id'],
        title: jsonMap['title'],
        date: DateTime.parse(jsonMap['date']),
        priority: jsonMap['priority'],
        completed: jsonMap['completed'] == 1);
  }

  @override
  String toString() {
    return toJsonMap().toString();
  }
}
