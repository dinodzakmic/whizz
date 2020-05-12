import 'package:whizz/models/task_model.dart';
import 'package:flutter/material.dart';

class AppState {
  final List<TaskModel> tasks;
  final bool loading;

  const AppState({@required this.tasks, this.loading});
  AppState.initialState()
      : this.tasks = List.unmodifiable([]),
        this.loading = false;

  AppState.fromJsonMap(Map jsonMap)
      : this.tasks = jsonMap['tasks'],
        this.loading = jsonMap['loading'];

  Map toJsonMap() => {
        'tasks': this.tasks,
        'loading': this.loading,
      };

  AppState copyWith({List<TaskModel> cTasks, bool cLoading}) => AppState(
        tasks: cTasks ?? this.tasks,
        loading: cLoading ?? this.loading,
      );
}
