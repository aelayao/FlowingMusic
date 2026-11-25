import 'dart:typed_data';

//model = estructura de los datos

class Cancion {
  final String title;
  final String artist;
  final String album;
  final String path;
  final Duration duration;
  final Uint8List? artwork;

  Cancion({
    required this.title,
    required this.artist,
    required this.album,
    required this.path,
    required this.duration,
    this.artwork,
  });
}
