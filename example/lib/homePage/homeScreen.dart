import 'package:flutter/material.dart';
import 'package:plugin_mirrar_example/homePage/homeScreenBloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    // TODO: implement initState
    _homeBloc = HomeBloc(context);
    _homeBloc.init();
    super.initState();
  }

  Widget loading() {
    return StreamBuilder<bool>(
        initialData: false,
        stream: _homeBloc.loadingCtrl.stream,
        builder: (context, snapshot) {
          if (snapshot.data == false) return Container();
          return const Material(
              color: Color(0xff70000000),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "app",
      child: Stack(
        children: [
          Scaffold(
              backgroundColor: Colors.white,
              body: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Welcome to Mirrar",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _homeBloc.brandIdController,
                        decoration: const InputDecoration(
                          label: Text("Brand ID"),
                          fillColor: Colors.blueGrey,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Please enter Brand ID",
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 1)),
                          disabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 1)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _homeBloc.onSubmit,
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          loading(),
        ],
      ),
    );
  }
}
