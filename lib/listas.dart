import 'package:material_ui/material_ui.dart';

class ListasScreen extends StatelessWidget {
  const ListasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: const [
        ListTileCard(title: 'Mis Favoritas', count: '5 canciones'),
        ListTileCard(title: 'Entrenamiento', count: '12 canciones'),
        ListTileCard(title: 'Rock & Pop', count: '8 canciones'),
      ],
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
