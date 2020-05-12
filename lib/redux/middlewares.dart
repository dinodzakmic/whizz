import 'package:whizz/app_state.dart';
import 'package:whizz/helpers/database_helpers.dart';
import 'package:whizz/models/task_model.dart';
import 'package:whizz/redux/actions.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> appStateMiddlewares(
    {AppState state = const AppState(tasks: [])}) {
  return [
    TypedMiddleware<AppState, GetTasksAction>(getAllTasks(state)),
    TypedMiddleware<AppState, AddTaskAction>(addTask(state)),
    TypedMiddleware<AppState, EditTaskAction>(editTask(state)),
    TypedMiddleware<AppState, DeleteTaskAction>(deleteTask(state)),
    TypedMiddleware<AppState, CompleteTaskAction>(completeTask(state)),
  ];
}

Middleware<AppState> getAllTasks(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UpdateLoadingAction(true));
    _getAllTasks().then((items) => store.dispatch(LoadTasksAction(items)));
  };
}

Future<List<TaskModel>> _getAllTasks() {
  final tasks = DatabaseHelpers.instance.getTasks();
  return tasks;
}

Middleware<AppState> addTask(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    _addTask(state, (action as AddTaskAction).task);
    next(action);
  };
}

Future<int> _addTask(AppState state, TaskModel task) {
  final result = DatabaseHelpers.instance.insertTask(task);
  return result;
}

Middleware<AppState> editTask(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    _editTask(state, (action as EditTaskAction).task);
    next(action);
  };
}

Future<int> _editTask(AppState state, TaskModel task) {
  final result = DatabaseHelpers.instance.updateTask(task);
  return result;
}

Middleware<AppState> deleteTask(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);
    _deleteTask(state, (action as DeleteTaskAction).task);
  };
}

Future<int> _deleteTask(AppState state, TaskModel task) {
  final result = DatabaseHelpers.instance.deleteTask(task.id);
  return result;
}

Middleware<AppState> completeTask(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);
    _completeTask(state, (action as CompleteTaskAction).task);
  };
}

Future<int> _completeTask(AppState state, TaskModel task) async {
  final result = await DatabaseHelpers.instance.updateTask(task);
  return result;
}
