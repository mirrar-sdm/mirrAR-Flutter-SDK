import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin_mirrar_example/homePage/homeScreen.dart';
import 'package:plugin_mirrar_example/launch_mirrar.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  // );
  // await Permission.storage.request();
  await Permission.camera.request();
  await Permission.storage.request();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mirrar Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
