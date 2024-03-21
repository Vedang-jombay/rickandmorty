import 'package:dio/dio.dart';

class ApiService {
  static Future<dynamic> fetchData() async {
    Dio dio = Dio();
    try {
      Response response = await dio.get('https://rickandmortyapi.com/api/character');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
