import 'package:whizz/app_state.dart';
import 'package:whizz/models/task_model.dart';
import 'package:whizz/redux/actions.dart';
import 'package:redux/redux.dart';

class TaskViewModel {
  static int id = -1;

  final List<TaskModel> tasks;
  final Function(TaskModel) onAddTask;
  final Function(TaskModel) onEditTask;
  final Function(TaskModel) onDeleteTask;
  final Function(TaskModel) onCompleteTask;

  TaskViewModel(
      {this.tasks,
      this.onAddTask,
      this.onEditTask,
      this.onDeleteTask,
      this.onCompleteTask});

  factory TaskViewModel.create(Store<AppState> store) {
    _onAddTask(TaskModel task) {
      store.dispatch(AddTaskAction(task));
    }

    _onEditTask(TaskModel task) {
      store.dispatch(EditTaskAction(task));
    }

    _onDeleteTask(TaskModel task) {
      store.dispatch(DeleteTaskAction(task));
    }

    _onCompleteTask(TaskModel task) {
      store.dispatch(CompleteTaskAction(task));
    }

    return TaskViewModel(
        tasks: store.state.tasks,
        onAddTask: _onAddTask,
        onEditTask: _onEditTask,
        onDeleteTask: _onDeleteTask,
        onCompleteTask: _onCompleteTask);
  }
}
