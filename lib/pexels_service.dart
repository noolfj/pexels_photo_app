import 'dart:convert';
import 'package:http/http.dart' as http;

class PexelsService {
  final String apiKey = 'dgi8xQq2ZJLl7qWhhZLWE0BjjMveZH9kgtc9UVXk50ffpz3BV9CD97DL';
  final String baseUrl = 'https://api.pexels.com/v1/';

  Future<List<dynamic>> fetchPhotos(int page, int perPage) async {
    final response = await http.get(
      Uri.parse('${baseUrl}curated?page=$page&per_page=$perPage'),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['photos'];
    } else {
      throw Exception('Не удалось загрузить фотографии');
    }
  }
}
