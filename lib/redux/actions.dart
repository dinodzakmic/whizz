import 'package:whizz/models/task_model.dart';

class GetTasksAction {}

class LoadTasksAction {
  final List<TaskModel> tasks;

  LoadTasksAction(this.tasks);
}

class UpdateLoadingAction {
  final bool isLoading;

  UpdateLoadingAction(this.isLoading);
}

class AddTaskAction {
  final TaskModel task;

  AddTaskAction(this.task);
}

class EditTaskAction {
  final TaskModel task;

  EditTaskAction(this.task);
}

class DeleteTaskAction {
  final TaskModel task;

  DeleteTaskAction(this.task);
}

class CompleteTaskAction {
  final TaskModel task;

  CompleteTaskAction(this.task);
}
