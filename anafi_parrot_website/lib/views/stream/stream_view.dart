import 'dart:html';
import 'package:anafi_parrot_website/widgets/centered_view/centered_view.dart';
import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:anafi_parrot_website/models/battery.dart';
import 'package:anafi_parrot_website/models/altitude.dart';
import 'package:anafi_parrot_website/models/stream.dart';
import 'dart:async';

class StreamView extends StatefulWidget {
  const StreamView({Key? key}) : super(key: key);

  @override
  _StreamView createState() => _StreamView();
}

class _StreamView extends State<StreamView> {
  late var responses;

  fetchData() {
    Timer.periodic(Duration(milliseconds: 24), (timer) {
      setState(() {
        responses = Future.wait([fetchBattery(), fetchAltitude()]);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CenteredView(
            child: FutureBuilder(
                future: responses,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Card(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 45.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        BatteryIndicator(
                                          batteryFromPhone: false,
                                          batteryLevel: 15,
                                          style: BatteryIndicatorStyle.flat,
                                          colorful: true,
                                          showPercentNum: false,
                                          mainColor:
                                              Color.fromARGB(255, 31, 229, 146),
                                          size: 45,
                                          ratio: 6.0,
                                          showPercentSlide: true,
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Text("15%",
                                            style: TextStyle(fontSize: 18)),
                                        Text("${snapshot.data!}"),
                                      ],
                                    ))))
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
