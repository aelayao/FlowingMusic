import 'package:flowing_music/elementos/texto.dart';
//import 'package:flowing_music/reproductor/canciones_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flowing_music/reproductor/service_musica.dart';

import '../temas/colores.dart';

class MiniPlyr extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback pause;

  const MiniPlyr({super.key, required this.onTap, required this.pause});

  @override
  State<MiniPlyr> createState() => _MiniPlyrState();
}

class _MiniPlyrState() extends State<MiniPlyr> {
  final ServiceMusica _serviceMusica = ServiceMusica();
  @override
  Widget build(BuildContext context) {
    final cancionAct = _serviceMusica.cancionAct;
    if (cancionAct == null) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: widget.onTap,

      child: Container(
        padding: EdgeInsets.all(15),
        height: 120,
        //margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [moradoOsc, transpMrep],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          border: Border(top: BorderSide(color: moradoP, width: 5)),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [rosaClr, rosaOsc],
                ),
              ),
              child: Icon(Icons.star_rounded, size: 40, color: rosa),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    cancionAct.title,
                    style: txtStyle(size: 16, color: rosaClr),
                  ),
                ],
              ),
            ),
            StreamBuilder<PlayerState>(
              stream: _serviceMusica.audioPlayer.playerStateStream,
              builder: ((context, snapshot) {
                final playerState = snapshot.data;
                final playing = playerState?.playing ?? false;
                final processingState = playerState?.processingState;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(color: azul),
                  );
                } else {
                  return IconButton(
                    icon: Icon(
                      playing == true ? Icons.pause : Icons.play_arrow,
                      color: blanco,
                      size: 40,
                    ),
                    onPressed: () {
                      if (playing == true) {
                        _serviceMusica.audioPlayer.pause();
                      } else {
                        _serviceMusica.audioPlayer.play();
                      }
                      widget.pause();
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
