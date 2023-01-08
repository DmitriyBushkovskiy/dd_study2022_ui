import 'package:dd_study2022_ui/internal/init_app.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/loader/loader_widget.dart';
import 'package:flutter/material.dart';
import 'data/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  
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
          AppNavigator.onGeneratedRoutes(settings, context, arg: settings.arguments),
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.grey[300],
            selectionHandleColor: Colors.grey[300],
            cursorColor: Colors.grey[300]),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: const TextStyle(fontFamily: 'OldSoviet')),
        ),
        primarySwatch: Colors.grey,
        primaryColor: Colors.red,
        fontFamily: 'OldSoviet',

        //textTheme: TextTheme(bodyText1: TextStyle(color: Colors.cyanAccent), bodyText2: TextStyle(color: Colors.cyanAccent))
      ),
      home: LoaderWidget.create(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
