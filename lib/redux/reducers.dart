import 'package:whizz/app_state.dart';
import 'package:whizz/models/task_model.dart';
import 'package:whizz/redux/actions.dart';
import 'package:redux/redux.dart';

AppState appStateReducer(AppState state, action) {
  return appReducer(state, action);
}

Reducer<AppState> appReducer = combineReducers<AppState>([
  TypedReducer<AppState, UpdateLoadingAction>(updateLoading),
  TypedReducer<AppState, LoadTasksAction>(loadAllTasks),
  TypedReducer<AppState, AddTaskAction>(addTask),
  TypedReducer<AppState, EditTaskAction>(editTask),
  TypedReducer<AppState, DeleteTaskAction>(deleteTask),
  TypedReducer<AppState, CompleteTaskAction>(completeTask),
]);

AppState updateLoading(AppState state, UpdateLoadingAction action) {
  return state.copyWith(cLoading: action.isLoading);
}

AppState loadAllTasks(AppState state, LoadTasksAction action) {
  final newTasks = action.tasks;

  return state.copyWith(cTasks: newTasks, cLoading: false);
}

AppState addTask(AppState state, AddTaskAction action) {
  final newTasks = List<TaskModel>.from(state.tasks)..add(action.task);

  return state.copyWith(cTasks: newTasks, cLoading: false);
}

AppState editTask(AppState state, EditTaskAction action) {
  final newTasks = List<TaskModel>.from(state.tasks)
      .map((existingTask) =>
          existingTask.id == action.task.id ? action.task : existingTask)
      .toList();

  return state.copyWith(cTasks: newTasks, cLoading: false);
}

AppState deleteTask(AppState state, DeleteTaskAction action) {
  final newTasks = List<TaskModel>.from(state.tasks)..remove(action.task);

  return state.copyWith(cTasks: newTasks, cLoading: false);
}

AppState completeTask(AppState state, CompleteTaskAction action) {
  final newTasks = List<TaskModel>.from(state.tasks)
      .map((existingTask) => existingTask.id == action.task.id
          ? existingTask.copyWith(completed: !existingTask.completed)
          : existingTask)
      .toList();

  return state.copyWith(cTasks: newTasks, cLoading: false);
}
