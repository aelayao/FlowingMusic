import 'package:flowing_music/elementos/texto.dart';
import 'package:flowing_music/reproductor/canciones_model.dart';
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
        height: 100,
        //margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [moradoOsc, transpMrep],
          ),
          borderRadius: BorderRadius.circular(40),
          border: Border(top: BorderSide(color: moradoP, width: 5)),
        ),
      ),
      /*Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),*/
    );
  }
}
