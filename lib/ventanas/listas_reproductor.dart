import 'package:material_ui/material_ui.dart';

import 'home.dart';
import '../temas/colores.dart';

class ListasRepro extends StatelessWidget {
  const ListasRepro({super.key});
  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset('assets/listas_bg.png', fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
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

          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: const [
              ListTileCard(title: 'Mis Favoritas', count: '5 canciones'),
              ListTileCard(title: 'Entrenamiento', count: '12 canciones'),
              ListTileCard(title: 'Rock & Pop', count: '8 canciones'),
            ],
          ),
        ],
      ),
    );
  }
}

class ListTileCard extends StatelessWidget {
  final String title;
  final String count;

  const ListTileCard({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF3F3268).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.playlist_play,
                color: Colors.purpleAccent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            count,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
