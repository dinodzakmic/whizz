import 'package:whizz/app_state.dart';
import 'package:whizz/models/task_model.dart';
import 'package:whizz/redux/actions.dart';
import 'package:whizz/routes.dart';
import 'package:whizz/viewmodels/task_viewmodel.dart';
import 'package:whizz/widgets/task_item_widget.dart';
import 'package:whizz/widgets/calendar_widget.dart';
import 'package:whizz/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TaskListScreen extends StatefulWidget {
  final String title;

  const TaskListScreen({Key key, this.title}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Future<List<TaskModel>> tasks;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TaskViewModel>(
      converter: (Store<AppState> store) => TaskViewModel.create(store),
      onInit: StoreProvider.of<AppState>(context).dispatch(GetTasksAction()),
      builder: (BuildContext context, TaskViewModel taskViewModel) {
        final tasksCount = taskViewModel.tasks.length;
        final completedTasksCount =
            taskViewModel.tasks.where((task) => task.completed).length;

        return Scaffold(
          body: Container(
            padding: EdgeInsets.only(top: 60, bottom: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.75)),
            child: Column(
              children: <Widget>[
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: <Widget>[
                //       ClipRRect(
                //         borderRadius: BorderRadius.circular(40),
                //         child: FlatButton(
                //           child: Text(
                //             'list',
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .title
                //                 .copyWith(color: Colors.white, fontSize: 30),
                //           ),
                //           onPressed: () {},
                //         ),
                //       ),
                //       ClipRRect(
                //         borderRadius: BorderRadius.circular(40),
                //         child: FlatButton(
                //           child: Text(
                //             'calendar',
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .title
                //                 .copyWith(color: Colors.white, fontSize: 30),
                //           ),
                //           onPressed: () {},
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: StoreProvider.of<AppState>(context).state.loading
                        ? Center(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ))
                        : CalendarWidget(
                            tasks: taskViewModel.tasks,
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: FlatButton(
                            child: Text('add',
                                style: Theme.of(context).textTheme.headline),
                            onPressed: () {
                              Navigator.of(context).pushNamed(AddTask);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
