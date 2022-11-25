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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _showFab = true;
  bool _showNotch = true;
  FloatingActionButtonLocation _fablocation =
      FloatingActionButtonLocation.endDocked;

  void _onShowNotchChanged(bool value) {
    setState(() {
      _showNotch = value;
    });
  }

  void _onShowFabChanged(bool val) {
    setState(() {
      _showFab = val;
    });
  }

  void _onFabLocationChanged(FloatingActionButtonLocation? loc) {
    setState(() {
      _fablocation = loc ?? FloatingActionButtonLocation.endDocked;
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      floatingActionButtonLocation: _fablocation,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("${widget.title} - $_counter"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        children: [
          SwitchListTile(
            value: _showNotch,
            onChanged: _onShowNotchChanged,
            title: const Text("Notch"),
          ),
          const Divider(),
          SwitchListTile(
            value: _showFab,
            onChanged: _onShowFabChanged,
            title: const Text("Fab"),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text("Fab locations"),
          ),
          RadioListTile(
              title: const Text("centerDocked"),
              value: FloatingActionButtonLocation.centerDocked,
              groupValue: _fablocation,
              onChanged: _onFabLocationChanged),
          RadioListTile(
              title: const Text("centerFloat"),
              value: FloatingActionButtonLocation.centerFloat,
              groupValue: _fablocation,
              onChanged: _onFabLocationChanged),
          RadioListTile(
              title: const Text("endDocked"),
              value: FloatingActionButtonLocation.endDocked,
              groupValue: _fablocation,
              onChanged: _onFabLocationChanged),
          RadioListTile(
              title: const Text("endFloat"),
              value: FloatingActionButtonLocation.endFloat,
              groupValue: _fablocation,
              onChanged: _onFabLocationChanged),
        ],
      ),
      floatingActionButton: !_showFab
          ? null
          : FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.bolt),
            ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: _BottomAppBarTest(
        fabLocation: _fablocation,
        showFab: _showFab,
        shape: _showNotch ? const CircularNotchedRectangle() : null,
      ),
    );
  }
}

class _BottomAppBarTest extends StatelessWidget {
  _BottomAppBarTest({
    required this.fabLocation,
    required this.showFab,
    this.shape,
  });

  final FloatingActionButtonLocation fabLocation;
  final CircularNotchedRectangle? shape;
  final bool showFab;
  final List<FloatingActionButtonLocation> centerVariants = [
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment:
            fabLocation == FloatingActionButtonLocation.centerDocked && showFab
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
