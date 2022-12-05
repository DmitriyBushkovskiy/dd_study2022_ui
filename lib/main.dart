import 'package:dd_study2022_ui/ui/app_navigator.dart';
import 'package:dd_study2022_ui/ui/roots/loader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: AppNavigator.key,
      onGenerateRoute: (settings) =>
          AppNavigator.onGeneratedRoutes(settings, context),
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.grey[300], selectionHandleColor: Colors.grey[300]),
        textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontFamily: 'SyneMono')
        ),
      ),
        primarySwatch: Colors.grey,
        primaryColor: Colors.red,
        fontFamily: 'SyneMono',
        //textTheme: TextTheme(bodyText1: TextStyle(color: Colors.cyanAccent), bodyText2: TextStyle(color: Colors.cyanAccent))
      ),
      home: LoaderWidget.create(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}