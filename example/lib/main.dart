import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin_mirrar_example/select_mode.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  // );
  // await Permission.storage.request();
  await Permission.camera.request();
  await Permission.storage.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

   @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Scaffold(
            body: SafeArea(
                child: Center(
                    child: Container(
                        width: 200,
                        height: 50,
                        child: RaisedButton(
                          child: Text("Launch Mirrar"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectMode()));
                          },
                          color: Colors.pink,
                          textColor: Colors.white,
                          splashColor: Colors.grey,
                         )
                        )
                       )
                      )
                    )
                  );
  }
}