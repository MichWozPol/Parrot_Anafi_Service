import 'package:anafi_parrot_website/variables/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Battery {
  final int battery;

  Battery({required this.battery});

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      battery: json['batteryCharge'],
    );
  }
}

Future<Battery> fetchBattery() async {
  final response = await http.get(Uri.parse('${globals.url}battery'));

  if (response.statusCode == 200) {
    return Battery.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed connection to server.');
  }
}
