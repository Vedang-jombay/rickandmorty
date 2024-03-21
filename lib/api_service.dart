import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<dynamic> fetchData() async {
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
