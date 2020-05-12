import 'package:whizz/app_state.dart';
import 'package:whizz/redux/middlewares.dart';
import 'package:whizz/redux/reducers.dart';
import 'package:whizz/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class App extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(
    appStateReducer,
    middleware: appStateMiddlewares(),
    initialState: AppState.initialState(),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
          title: 'WHIZZ',
          theme: ThemeData(
            primaryColor: Colors.red,
            textTheme: TextTheme(
              headline: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              title: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5),
              subtitle: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              body1: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              body2: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          routes: routes,
          initialRoute: ListTasks),
    );
  }
}
