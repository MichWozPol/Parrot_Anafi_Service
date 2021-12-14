import 'package:anafi_parrot_website/variables/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class DroneStream {
  final List<dynamic>? stream;
  final int battery;
  final double altitude;
  final List<double> gpsLocation;

  DroneStream(
      {required this.battery,
      required this.altitude,
      required this.gpsLocation,
      required this.stream});

  factory DroneStream.fromJson(List<Map<String, dynamic>> json) {
    return DroneStream(
        battery: json[0]['batteryCharge'],
        altitude: json[1]['altitude'],
        gpsLocation: [json[2]['longitude'], json[2]['latitude']],
        stream: json[3]['stream']);
  }
}

Future<DroneStream> fetchStream() async {
  var responses = await Future.wait([
    http.get(Uri.parse('${globals.url}battery')),
    http.get(Uri.parse('${globals.url}altitude')),
    http.get(Uri.parse('${globals.url}gpslocation')),
    http.get(Uri.parse('${globals.url}stream')),
  ]);

  if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
    return DroneStream.fromJson([
      jsonDecode(responses[0].body),
      jsonDecode(responses[1].body),
      jsonDecode(responses[2].body),
      jsonDecode(responses[3].body)
    ]);
  } else {
    throw Exception('Failed connection to server.');
  }
}
