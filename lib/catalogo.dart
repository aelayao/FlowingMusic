
import 'dart:convert';
import 'package:flutter/services.dart';

class Song {
  final String title;
  final String audioPath;
  final String imagePath;

  const Song({
    required this.title,
    required this.audioPath,
    required this.imagePath,
  });

}

Future<List<Song>> loadSongCatalog() async {
  final String jsonString =
      await rootBundle.loadString('assets/canciones.json');

  final List<dynamic> jsonData = jsonDecode(jsonString);

  return jsonData.map((song) {
    return Song(
      title: song['title'],
      audioPath: song['audio'],
      imagePath: song['image'],
    );
  }).toList();
}
