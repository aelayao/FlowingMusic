import 'package:flowing_music/elementos/texto.dart';
import 'package:flowing_music/ventanas/home.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_ui/material_ui.dart';

import '../temas/colores.dart';
import '../reproductor/service_musica.dart';

class Reproductor extends StatefulWidget {
  const new({super.key});

  @override
  State<Reproductor> createState() => _ReproductorState();
}

class _ReproductorState extends State<Reproductor> {
  final ServiceMusica _serviceMusica = ServiceMusica();
  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset('assets/ply_bg.png', fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cancionAct = _serviceMusica.cancionAct;
    if (cancionAct == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            Center(
              child: Text(
                'No se esta reproduciendo ninguna canción.',
                style: txtStyle(),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: Border(top: BorderSide(color: moradoP, width: 5)),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: Icon(Icons.arrow_back, color: blanco),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: moradoMed,
                      boxShadow: [
                        BoxShadow(
                          color: moradoMed,
                          blurRadius: 50,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 230,
                            height: 230,
                            decoration: const BoxDecoration(
                              color: negro,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 140,
                            height: 140,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: rosaOsc,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(Icons.image, size: 90, color: rosa),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    cancionAct.title,
                    style: txtStyle(size: 24, weight: bold, fam: russo),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    cancionAct.artist,
                    style: txtStyle(size: 20, weight: regular),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  StreamBuilder<Duration>(
                    stream: _serviceMusica.audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration =
                          _serviceMusica.audioPlayer.duration ?? Duration.zero;

                      return Column(
                        children: [
                          Slider(
                            value: position.inMilliseconds.toDouble(),
                            max: duration.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              _serviceMusica.audioPlayer.seek(
                                Duration(milliseconds: value.toInt()),
                              );
                              if (value >=
                                  duration.inMilliseconds.toDouble() - 1000) {
                                _serviceMusica.next();
                                setState(() {});
                              }
                            },
                            onChangeEnd: (value) {
                              _serviceMusica.audioPlayer.playerStateStream
                                  .listen((state) {
                                    if (state.processingState ==
                                        ProcessingState.completed) {
                                      _serviceMusica.next();
                                      setState(() {});
                                    }
                                  });
                            },
                            activeColor: rosaClr,
                            inactiveColor: blanco, //placeholderS
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatoDuracion(position),
                                  style: txtStyle(weight: bold, size: 16),
                                ),
                                Text(
                                  _formatoDuracion(duration),
                                  style: txtStyle(weight: bold, size: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /*IconButton(
                  onPressed: () async {
                    _serviceMusica.shuffle();
                    setState(() {});
                  },
                  icon: Icon(Icons.shuffle, size: 45),
                  color: blanco,
                ),*/
                      IconButton(
                        onPressed: () async {
                          await _serviceMusica.prev();
                          setState(() {});
                        },
                        icon: Icon(Icons.skip_previous, size: 55),
                        color: blanco,
                      ),
                      StreamBuilder(
                        stream: _serviceMusica.audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final playing = playerState?.playing;
                          final processingState = playerState?.processingState;
                          if (processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(color: azul),
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.all(8),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: blanco, width: 2),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  await _serviceMusica.pause();
                                  setState(() {});
                                },

                                icon: Icon(
                                  playing == true
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 60,
                                  color: blanco,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        onPressed: () async {
                          await _serviceMusica.next();
                          setState(() {});
                        },
                        icon: Icon(Icons.skip_next, size: 55),
                        color: blanco,
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatoDuracion(Duration duration) {
    String dosDig(int n) => n.toString().padLeft(2, '0');
    String minutes = dosDig(duration.inMinutes.remainder(60));
    String seconds = dosDig(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
