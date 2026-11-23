import 'dart:io';

import 'package:just_audio/just_audio.dart';

import 'canciones_model.dart';

import 'package:path/path.dart' as path;

//clase con la funcionalidad de obtener archivos(?)

class ServiceMusica {
  static final ServiceMusica _instance = ServiceMusica._internal();

  factory ServiceMusica() => _instance;
  ServiceMusica._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Cancion> _canciones = [];
  int _currentIndex = -1;

  AudioPlayer get audioPlayer => _audioPlayer;
  List<Cancion> get songs => _canciones;
  int get currentIndex => _currentIndex;
  Cancion? get cancionAct =>
      (_currentIndex >= 0 && _currentIndex < _canciones.length)
      ? _canciones[_currentIndex]
      : null;

  //cargar las canciones al servicio

  Future<List<Cancion>> scanCancion() async {
    _canciones.clear();

    try {
      final allDir = await _getAllDir();

      for (String dirPath in allDir) {
        await _scanDirR(dirPath);
      }

      _canciones = _rDupli(_canciones);
      _canciones.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    } catch (e) {
      print("Error al buscar las canciones: $e");
    }

    return _canciones;
  }

  Future<List<String>> _getAllDir() async {
    List<String> dirs = [];

    final primaryPaths = [
      //'/storage/emulated/0',
      '/storage/emulated/0/Music',
      '/storage/emulated/0/Download',
      //'/storage/emulated/0/Android/data',
      //'/storage/emulated/0/Android/media',
      '/storage/emulated/0/Media',
      '/storage/emulated/0/Audio',
      //'/storage/emulated/0/Podcasts',
      //'/storage/emulated/0/AudioBooks',
      //'/storage/emulated/0/Ringtones',
      //'/storage/emulated/0/Alarms',
      //'/sdcard',
    ];

    final usePaths = <String>[
      '/storage/emulated/0/Music',
      '/storage/emulated/0/Download',
      '/storage/emulated/0/Media',
      '/storage/emulated/0/Audio',
    ];

    /*final secondaryPaths = [
      //'/storage/emulated/1',
      '/storage/sdcard1',
      //'/storage/sdcard2',
      '/storage/extSdCard',
      '/storage/external_SD',
      '/storage/external_SDCard',
    ];*/

    dirs.addAll(primaryPaths);
    //dirs.addAll(secondaryPaths);

    /*try {
      final strgDir = Directory('/storage/emulated/0/Music');
      if (await strgDir.exists()) {
        await for (FileSystemEntity entity in strgDir.list(recursive: false)) {
          if (entity is Directory && !dirs.contains(entity.path)) {
            dirs.add(entity.path);
          }
        }
      }
    } catch (e) {
      print("Error al intentar obtener los directorios de almacenamiento: $e");
    }*/

    List<String> existDirs = [];
    for (String dir in usePaths) {
      try {
        final directory = Directory(dir);
        if (await directory.exists()) {
          existDirs.add(dir);
        }
      } catch (e) {
        print("Error revisando el directorio $dir: $e");
        continue;
      }
    }
    return existDirs;
  }

  Future<void> _scanDirR(String dirPath) async {
    try {
      final directory = Directory(dirPath);

      await for (FileSystemEntity entity in directory.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File && _isAudioFile(entity.path)) {
          try {
            final cancion = await _crearCancion(entity);
            if (cancion != null) {
              _canciones.add(cancion);
            }
          } catch (e) {
            print("a");
            continue;
          }
        }
      }
    } catch (e) {
      print("Error escaneando directorio $dirPath: $e");
    }
  }

  bool _isAudioFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    final audExtension = [
      '.mp3',
      '.wav',
      '.flac',
      '.aac',
      '.ogg',
      '.m4a',
      '.wma',
      '.opus',
      '.amr',
    ];
    return audExtension.contains(extension);
  }

  Future<Cancion?> _crearCancion(File file) async {
    try {
      final fileNom = path.basenameWithoutExtension(file.path);
      String title = fileNom;
      String artist = 'Artísta Desconocido';
      String album = 'Album Desconocido';
      Duration duration = Duration.zero;
      if (fileNom.contains(' - ')) {
        final partes = fileNom.split(' - ');
        if (partes.length >= 2) {
          artist = partes[0].trim();
          title = partes.sublist(1).join(' - ').trim();
        }
      }
      /*try {
        final tempPlayer = AudioPlayer();
        await tempPlayer.setFilePath(file.path);

        if (tempPlayer.duration != null) {
          duration = tempPlayer.duration!;
        }

        await tempPlayer.dispose();
      } catch (e) {
        
      }*/

      return Cancion(
        title: title,
        artist: artist,
        album: album,
        path: file.path,
        duration: duration,
      );
    } catch (e) {
      print("Error creando la cancion mediante el archivo ${file.path}: $e");
      return null;
    }
  }

  List<Cancion> _rDupli(List<Cancion> canciones) {
    final seen = <String>{};
    return canciones.where((cancion) {
      final key =
          '${cancion.title}-${cancion.artist}-${cancion.duration.inSeconds}';
      return seen.add(key);
    }).toList();
  }

  Future<void> play(int index) async {
    if (index >= 0 && index < _canciones.length) {
      _currentIndex = index;
      await _audioPlayer.setFilePath(_canciones[index].path);
      await _audioPlayer.play();
    }
  }

  Future<void> pause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> next() async {
    if (_currentIndex < _canciones.length - 1) {
      await play(_currentIndex + 1);
    } else {
      await play(0);
    }
  }

  Future<void> prev() async {
    if (_currentIndex > 0) {
      await play(_currentIndex - 1);
    } else {
      await play(_canciones.length - 1);
    }
  }

  Future<void> timeline(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void shuffle() {
    if (_canciones.length > 1) {
      final cancionAct = _canciones[_currentIndex];
      _canciones.shuffle();

      final newIdx = _canciones.indexOf(cancionAct);
      if (newIdx != _currentIndex) {
        final a = _canciones[_currentIndex];
        _canciones[_currentIndex] = cancionAct;
        _canciones[newIdx] = a;
      }
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    _canciones.clear();
    _currentIndex = -1;
  }
}
