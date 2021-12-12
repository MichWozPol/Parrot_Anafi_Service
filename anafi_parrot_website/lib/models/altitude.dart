import 'package:anafi_parrot_website/variables/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Altitude {
  final double altitude;

  Altitude({required this.altitude});

  factory Altitude.fromJson(Map<String, dynamic> json) {
    return Altitude(
      altitude: json['altitude'],
    );
  }
}

Future<Altitude> fetchAltitude() async {
  final response = await http.get(Uri.parse('${globals.url}altitude'));

  if (response.statusCode == 200) {
    return Altitude.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed connection to server.');
  }
}
