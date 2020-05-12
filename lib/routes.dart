import 'package:whizz/screens/add_edit_task_screen.dart';
import 'package:whizz/screens/task_list_screen.dart';

const String ListTasks = '/';
const String AddTask = 'add';

final routes = {
  ListTasks: (context) => TaskListScreen(title: 'WHIZZ'),
  AddTask: (context) => AddEditTaskScreen(),
};
