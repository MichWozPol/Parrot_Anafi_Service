import 'package:anafi_parrot_website/views/home/home_content_desktop.dart';
import 'package:anafi_parrot_website/views/home/home_content_mobile.dart';
import 'package:anafi_parrot_website/widgets/centered_view/centered_view.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:anafi_parrot_website/models/connection.dart';
import 'dart:async';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  late Future<Connection> futureConnection;
  Timer? _timerClock;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _timerClock!.cancel();
    super.dispose();
  }

  fetchData() {
    _timerClock = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        futureConnection = fetchConnection();
      });
    });
  }

  List checkConnection(bool connection) {
    var title = '';
    var color = Color.fromARGB(0, 0, 0, 0);
    bool enabled = true;
    if (connection) {
      title = 'Enter Live View';
      color = Color.fromARGB(255, 31, 229, 146);
      enabled = true;
    } else {
      title = 'Drone is not connected!';
      color = Color.fromARGB(255, 220, 20, 60);
      enabled = false;
    }
    return [title, color, enabled];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CenteredView(
            child: FutureBuilder<Connection>(
                future: futureConnection,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Expanded(
                            child: ScreenTypeLayout(
                          mobile: HomeContentMobile(
                              checkConnection(snapshot.data!.connection)),
                          desktop: HomeContentDesktop(
                              checkConnection(snapshot.data!.connection)),
                        ))
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                        'Server is not responding. Please try later.');
                  }
                  return const CircularProgressIndicator();
                })));
  }
}
