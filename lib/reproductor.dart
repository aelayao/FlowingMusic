
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'catalogo.dart';

final AudioPlayer audioPlayer = AudioPlayer();

final ValueNotifier<String> currentSongTitle =
    ValueNotifier('Selecciona una canción');

final ValueNotifier<String> currentSongImage =
    ValueNotifier('');

final ValueNotifier<bool> songSelected =
    ValueNotifier(false);

// Lista que recibirá las canciones del archivo JSON.
final List<Song> songList = [];

int currentSongIndex = -1;

// Reproducir una canción por su posición en la lista.
Future<void> playSongAt(int index) async {
  if (index < 0 || index >= songList.length) return;

  try {
    currentSongIndex = index;

    final song = songList[index];

    currentSongTitle.value = song.title;
    currentSongImage.value = song.imagePath;
    songSelected.value = true;

    await audioPlayer.setAsset(song.audioPath);
    await audioPlayer.play();
  } catch (error) {
    debugPrint('Error al reproducir: $error');
  }
}

// Reproducir la siguiente canción.
Future<void> nextSong() async {
  if (songList.isEmpty) return;

  final nextIndex = currentSongIndex < 0
      ? 0
      : (currentSongIndex + 1) % songList.length;

  await playSongAt(nextIndex);
}

// Reproducir la canción anterior.
Future<void> previousSong() async {
  if (songList.isEmpty) return;

  final previousIndex = currentSongIndex < 0
      ? 0
      : (currentSongIndex - 1 + songList.length) %
          songList.length;

  await playSongAt(previousIndex);
}

// Convertir la duración a minutos y segundos.
String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60);

  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

// Reproductor inferior.
class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF28235C),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              ValueListenableBuilder<String>(
                valueListenable: currentSongImage,
                builder: (context, image, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: image.isEmpty
                        ? const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 42,
                          )
                        : Image.asset(
                            image,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                  );
                },
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: currentSongTitle,
                  builder: (context, title, child) {
                    return Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ),

              ValueListenableBuilder<bool>(
                valueListenable: songSelected,
                builder: (context, selected, child) {
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: selected ? previousSong : null,
                      ),

                      StreamBuilder<bool>(
                        stream: audioPlayer.playingStream,
                        initialData: false,
                        builder: (context, snapshot) {
                          final isPlaying = snapshot.data ?? false;

                          return IconButton(
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: !selected
                                ? null
                                : () {
                                    if (isPlaying) {
                                      audioPlayer.pause();
                                    } else {
                                      audioPlayer.play();
                                    }
                                  },
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: selected ? nextSong : null,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Barra de progreso.
          StreamBuilder<Duration?>(
            stream: audioPlayer.durationStream,
            builder: (context, durationSnapshot) {
              final duration =
                  durationSnapshot.data ?? Duration.zero;

              return StreamBuilder<Duration>(
                stream: audioPlayer.positionStream,
                builder: (context, positionSnapshot) {
                  final position =
                      positionSnapshot.data ?? Duration.zero;

                  final maxDuration =
                      duration.inMilliseconds.toDouble();

                  final currentPosition =
                      position.inMilliseconds.toDouble().clamp(
                    0.0,
                    maxDuration > 0 ? maxDuration : 1.0,
                  );

                  return Column(
                    children: [
                      Slider(
                        value: currentPosition,
                        min: 0,
                        max: maxDuration > 0
                            ? maxDuration
                            : 1.0,
                        activeColor: const Color(0xFF9B8CFF),
                        inactiveColor: Colors.white24,
                        onChanged: duration == Duration.zero
                            ? null
                            : (value) {
                                audioPlayer.seek(
                                  Duration(
                                    milliseconds: value.round(),
                                  ),
                                );
                              },
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDuration(position),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              formatDuration(duration),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
