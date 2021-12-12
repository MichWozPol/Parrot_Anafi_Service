import 'package:anafi_parrot_website/variables/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class DroneStream {
  final Stream<int> stream;

  DroneStream({required this.stream});

  factory DroneStream.fromJson(Map<String, dynamic> json) {
    return DroneStream(stream: json['stream']);
  }
}

Future<DroneStream> fetchStream() async {
  final response = await http.get(Uri.parse('${globals.url}stream'));

  if (response.statusCode == 200) {
    return DroneStream.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed connection to server.');
  }
}
