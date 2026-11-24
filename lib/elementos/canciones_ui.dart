import 'package:flowing_music/elementos/texto.dart';
import 'package:flowing_music/reproductor/canciones_model.dart';
import 'package:material_ui/material_ui.dart';

import '../temas/colores.dart';

class SongTile extends StatelessWidget {
  final Cancion cancion;
  final bool isPlaying;
  final VoidCallback? onTap;

  const SongTile({
    super.key,
    required this.cancion,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12, left: 5, right: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [transpP, transpL],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border(bottom: BorderSide(color: negro, width: 5)),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isPlaying ? [rosaOsc, rosaClr] : [rosaClr, rosaOsc],
              ),
            ),
            child: Icon(
              isPlaying ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 40,
              color: isPlaying ? rosa : rosaClr,
            ),
          ),
          title: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            cancion.title,
            style: isPlaying
                ? txtStyle(size: 16, color: rosaClr)
                : txtStyle(size: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cancion.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: txtStyle(size: 14, weight: regular),
              ),
            ],
          ),
          trailing: cancion.duration.inSeconds > 0
              ? Text(
                  _formatoDuracion(cancion.duration),
                  style: txtStyle(size: 16),
                )
              : Text('--:--', style: txtStyle(size: 16)),
          onTap: onTap,
        ),
      ),
    );
  }

  String _formatoDuracion(Duration duration) {
    String dosDig(int n) => n.toString().padLeft(2, '0');
    final int minutes = duration.inMinutes.remainder(60);
    final String seconds = dosDig(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
