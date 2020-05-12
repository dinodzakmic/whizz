import 'package:whizz/app_state.dart';
import 'package:whizz/helpers/formatters.dart';
import 'package:whizz/models/task_model.dart';
import 'package:whizz/viewmodels/task_viewmodel.dart';
import 'package:whizz/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AddEditTaskScreen extends StatefulWidget {
  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  TaskModel task;
  Function callback;
  bool initial;

  final _formKey = GlobalKey<FormState>();
  String _title;
  DateTime _date = DateTime.now();
  String _priority;

  final TextEditingController _titleControler = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<String> _priorities = ['Low', 'Medium', 'High'];

  _handleDatePicker(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (date != null && date != _date) {
      setState(() {
        _date = date;
        _dateController.text = dateFormatter.format(_date);
      });
    }
  }

  _submit(BuildContext context, TaskViewModel taskViewModel) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      TaskModel newTask = TaskModel.withId(
          id: task?.id ?? null,
          title: _titleControler.text,
          date: _date,
          priority: _priority,
          completed: task?.completed ?? false);

      if (task == null) {
        taskViewModel.onAddTask(newTask);
      } else {
        taskViewModel.onEditTask(newTask);
      }

      Navigator.of(context).pop();
    }
  }

  _delete(BuildContext context, TaskViewModel taskViewModel) {
    taskViewModel.onDeleteTask(task);

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = dateFormatter.format(_date);
    initial = true;
  }

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (routes != null) task = routes['task'] as TaskModel;

    if (initial && task != null) {
      _titleControler.text = task.title;
      _date = task.date;
      _priority = task.priority;

      initial = false;
    }

    return StoreConnector(
        converter: (Store<AppState> store) => TaskViewModel.create(store),
        builder: (BuildContext buildContext, TaskViewModel taskViewModel) {
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 50, bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.75)),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'add task',
                                  style: Theme.of(context).textTheme.title,
                                ),
                                Divider(),
                                EmptyWidget(
                                  height: 40,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: TextFormField(
                                          initialValue: _title,
                                          controller: _titleControler,
                                          decoration: InputDecoration(
                                            counterText: 'title',
                                            counterStyle: TextStyle(
                                              fontSize: 14,
                                            ),
                                            border: UnderlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.only(left: 5),
                                          ),
                                          validator: (value) =>
                                              value.trim().isEmpty
                                                  ? 'Please enter a title!'
                                                  : null,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: TextFormField(
                                          readOnly: true,
                                          onTap: () {
                                            _handleDatePicker(context);
                                          },
                                          controller: _dateController,
                                          decoration: InputDecoration(
                                            counterText: 'date',
                                            counterStyle: TextStyle(
                                              fontSize: 14,
                                            ),
                                            border: UnderlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.only(left: 5),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: DropdownButtonFormField(
                                          items: _priorities.map((priority) {
                                            return DropdownMenuItem(
                                              value: priority,
                                              child: Text(priority),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _priority = value;
                                            });
                                          },
                                          onSaved: (value) => _priority = value,
                                          decoration: InputDecoration(
                                            counterText: 'priority',
                                            counterStyle: TextStyle(
                                              fontSize: 14,
                                            ),
                                            border: UnderlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.only(left: 5),
                                          ),
                                          elevation: 0,
                                          isDense: true,
                                          value: _priority,
                                          validator: (value) => value == null
                                              ? 'Please select a priority!'
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
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
                                child: Text('back',
                                    style:
                                        Theme.of(context).textTheme.headline),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                          task != null
                              ? Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: FlatButton(
                                      child: Text('delete',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline),
                                      onPressed: () {
                                        _delete(context, taskViewModel);
                                      },
                                    ),
                                  ),
                                )
                              : EmptyWidget(),
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FlatButton(
                                child: Text('save',
                                    style:
                                        Theme.of(context).textTheme.headline),
                                onPressed: () {
                                  _submit(context, taskViewModel);
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
            ),
          );
        });
  }
}
