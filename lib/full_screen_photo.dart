import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FullScreenPhoto extends StatelessWidget {
  final String photoUrl;

  FullScreenPhoto({required this.photoUrl});

  Future<void> _saveToGallery(BuildContext context, String url) async {
    try {
      var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Сохранено в галерею')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось сохранить фото')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении фото')),
      );
    }
  }

  void _showQualityOptions(BuildContext context, String baseUrl) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.download),
              title: Text('Высокое качество'),
              onTap: () {
                Navigator.of(context).pop();
                _saveToGallery(context, baseUrl.replaceAll('medium', 'original'));
              },
            ),
            ListTile(
              leading: Icon(Icons.download),
              title: Text('Среднее качество'),
              onTap: () {
                Navigator.of(context).pop();
                _saveToGallery(context, baseUrl);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = photoUrl.replaceAll('_medium', '');

    return Scaffold(
      appBar: AppBar(
        title: Text('Фото'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _showQualityOptions(context, baseUrl),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(photoUrl),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.download),
              onPressed: () => _showQualityOptions(context, baseUrl),
            ),
            ElevatedButton(
              child: Text('Скачать'),
              onPressed: () => _saveToGallery(context, photoUrl),
            ),
          ],
        ),
      ),
    );
  }
}
