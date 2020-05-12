import 'package:whizz/app_state.dart';
import 'package:whizz/helpers/formatters.dart';
import 'package:whizz/models/task_model.dart';
import 'package:whizz/routes.dart';
import 'package:whizz/viewmodels/task_viewmodel.dart';
import 'package:whizz/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TaskItemWidget extends StatefulWidget {
  final TaskModel task;
  final EdgeInsets padding;
  final bool isFirst;

  const TaskItemWidget({
    Key key,
    @required this.task,
    this.padding,
    this.isFirst = false,
  }) : super(key: key);

  @override
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: (Store<AppState> store) => TaskViewModel.create(store),
      builder: (BuildContext context, TaskViewModel taskViewModel) {
        return Container(
          padding: widget.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget.isFirst
                  ? Divider(
                      height: 5,
                    )
                  : EmptyWidget(),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(AddTask, arguments: {
                    'task': widget.task,
                  });
                },
                title: Text(
                  widget.task.title,
                  style: Theme.of(context).textTheme.body1.copyWith(
                        decoration: widget.task.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      dateFormatter.format(widget.task.date),
                      style: Theme.of(context).textTheme.body2.copyWith(
                            decoration: widget.task.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                    ),
                    EmptyWidget(
                      width: 30,
                    ),
                    Text(
                      widget.task.priority,
                      style: Theme.of(context).textTheme.body2.copyWith(
                            decoration: widget.task.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                    ),
                  ],
                ),
                trailing: Checkbox(
                  onChanged: (value) {
                    setState(() {
                      taskViewModel.onCompleteTask(widget.task);
                    });
                  },
                  value: widget.task.completed,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              Divider(
                height: 5,
              ),
            ],
          ),
        );
      },
    );
  }
}
