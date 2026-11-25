import 'package:flowing_music/elementos/texto.dart';
import 'package:flowing_music/reproductor/canciones_model.dart';
import 'package:material_ui/material_ui.dart';

import '../temas/colores.dart';

class SongNxt extends StatelessWidget {
  final Cancion? sigCancion;
  //final bool isPlaying;
  final VoidCallback? onTap;

  const SongNxt({super.key, required this.sigCancion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final titulo = sigCancion?.title ?? 'Fin de la lista de reproducción.';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: sigCancion != null ? onTap : null,
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5),
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
                    colors: [rosaOsc, rosaClr],
                  ),
                ),
                child: Icon(Icons.star_outline_rounded, size: 40, color: rosa),
              ),
              subtitle: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                titulo,
                style: txtStyle(
                  size: 16,
                  color: Color.fromRGBO(54, 51, 57, 0.6),
                ),
              ),
              title: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "Siguiente canción...",
                style: txtStyle(
                  size: 13,
                  color: Color.fromRGBO(238, 247, 253, .6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
