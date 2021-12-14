import 'package:anafi_parrot_website/widgets/centered_view/centered_view.dart';
import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:anafi_parrot_website/models/stream.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class StreamView extends StatefulWidget {
  const StreamView({Key? key}) : super(key: key);
  @override
  _StreamView createState() => _StreamView();
}

class _StreamView extends State<StreamView> {
  late Future<DroneStream> responses;
  Timer? _timerClock;

  fetchData() {
    _timerClock = Timer.periodic(const Duration(milliseconds: 24), (timer) {
      setState(() {
        responses = fetchStream();
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CenteredView(
            child: FutureBuilder(
                future: responses,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Flexible(
                                child: Card(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    margin: const EdgeInsets.all(10.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16.0, 12.0, 16.0, 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      BatteryIndicator(
                                                        batteryFromPhone: false,
                                                        batteryLevel: snapshot
                                                            .data!.battery,
                                                        style:
                                                            BatteryIndicatorStyle
                                                                .flat,
                                                        colorful: true,
                                                        showPercentNum: false,
                                                        mainColor: const Color
                                                                .fromARGB(
                                                            255, 31, 229, 146),
                                                        size: 45,
                                                        ratio: 6.0,
                                                        showPercentSlide: true,
                                                      ),
                                                      const SizedBox(
                                                        width: 25,
                                                      ),
                                                      Text(
                                                          "${snapshot.data!.battery}%",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      "Altitude: ${snapshot.data!.altitude}m",
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      "Latitude: ${snapshot.data!.gpsLocation[1]}",
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      "Longitude: ${snapshot.data!.gpsLocation[0]}",
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                ],
                                              ))
                                        ])),
                              ),
                            ],
                          ),
                          Expanded(
                            child: FlutterMap(
                                options: MapOptions(
                                  center: latLng.LatLng(
                                      snapshot.data!.gpsLocation[1] < 90
                                          ? snapshot.data!.gpsLocation[1]
                                          : 25,
                                      snapshot.data!.gpsLocation[0] < 90
                                          ? snapshot.data!.gpsLocation[0]
                                          : 25),
                                  zoom: 13.0,
                                ),
                                layers: [
                                  TileLayerOptions(
                                      urlTemplate:
                                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      subdomains: ['a', 'b', 'c'],
                                      attributionBuilder: (_) {
                                        return const Text(
                                            "© OpenStreetMap contributors");
                                      }),
                                  MarkerLayerOptions(markers: [
                                    Marker(
                                      width: 20.0,
                                      height: 20.0,
                                      point: latLng.LatLng(
                                          snapshot.data!.gpsLocation[0] < 90
                                              ? snapshot.data!.gpsLocation[0]
                                              : 25,
                                          snapshot.data!.gpsLocation[0] < 90
                                              ? snapshot.data!.gpsLocation[1]
                                              : 25),
                                      builder: (context) => Container(
                                          child:
                                              Icon(Icons.add_location_rounded)),
                                    ),
                                  ])
                                ]),
                          ),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Text(
                        'Server is not responding. Please try later.');
                  }
                  return const CircularProgressIndicator();
                })));
  }
}
