import 'package:anafi_parrot_website/variables/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Connection {
  final bool connection;

  Connection({required this.connection});

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      connection: json['connection'],
    );
  }
}

Future<Connection> fetchConnection() async {
  final response = await http.get(Uri.parse('${globals.url}connection'));

  if (response.statusCode == 200) {
    return Connection.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed connection to server.');
  }
}
