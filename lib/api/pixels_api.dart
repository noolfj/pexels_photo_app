import 'package:http/http.dart' as http;
import 'dart:convert';

// Функция для получения фотографий с Pexels API
Future<List<String>> fetchPhotos(int page, int perPage, String apiKey) async {
  final response = await http.get(
    Uri.parse('https://api.pexels.com/v1/curated?per_page=$perPage&page=$page'),
    headers: {
      'Authorization': apiKey,
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<dynamic> photos = data['photos'];
    List<String> photoUrls = [];

    print('Photos data: $photos'); // Для отладки

    for (var item in photos) {
      // Проверка существования ключа 'src' и 'regular'
      if (item.containsKey('src') && item['src'].containsKey('regular') && item['src']['regular'] != null) {
        photoUrls.add(item['src']['regular']);
      } else {
        print('Received null or missing URL in response: $item');
      }
    }

    print('Processed photo URLs: $photoUrls'); // Для отладки
    return photoUrls;
  } else {
    // Обработка ошибки
    throw Exception('Failed to load photos');
  }
}
