import 'package:material_ui/material_ui.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes del Reproductor'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          SwitchListTile(
            title: const Text('Modo Oscuro'),
            subtitle: const Text('Activar o desactivar tema oscuro'),
            value: true,
            onChanged: (bool val) {},
          ),
          SwitchListTile(
            title: const Text('Reproducción Aleatoria'),
            subtitle: const Text(
              'Reproducir canciones en orden aleatorio',
            ),
            value: false,
            onChanged: (bool val) {},
          ),
        ],
      ),
    );
  }
}