import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'character.dart';

final charactersProvider = FutureProvider<List<Character>>((ref) async {
  Dio dio = Dio();
  try {
    Response response = await dio.get('https://rickandmortyapi.com/api/character');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.data['results'];
      return jsonData.map((character) => Character.fromJson(character)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  } catch (e) {
    throw Exception('Failed to load characters: $e');
  }
});
