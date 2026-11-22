//model = estructura de los datos

class Cancion {
  final String title;
  final String artist;
  final String album;
  final String path;
  final Duration duration;

  Cancion({
    required this.title,
    required this.artist,
    required this.album,
    required this.path,
    required this.duration,
  });
}
