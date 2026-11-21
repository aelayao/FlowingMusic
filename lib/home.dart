import 'package:material_ui/material_ui.dart';

import 'ajustes.dart';
import 'listas.dart';
import 'reproductor.dart';
import 'catalogo.dart';
import 'temas/colores.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    loadSongs();
  }

  // Cargar las canciones desde el archivo JSON.
  Future<void> loadSongs() async {
    try {
      final songs = await loadSongCatalog();

      songList
        ..clear()
        ..addAll(songs);

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = null;
      });

      debugPrint('Canciones cargadas: ${songList.length}');
    } catch (error) {
      debugPrint('Error al cargar canciones: $error');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'No se pudo cargar el catálogo.';
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Flowing Music',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AjustesScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Pestañas.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [transpMo, transpM]),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelStyle: TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  indicator: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    gradient: LinearGradient(colors: [moradoClr, blanco]),
                  ),
                  labelColor: moradoOsc,
                  unselectedLabelColor: negro,
                  tabs: const [
                    Tab(text: 'Canciones'),
                    Tab(text: 'Listas'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Contenido de las pestañas.
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Pestaña de canciones.
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (errorMessage != null)
                    Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  else if (songList.isEmpty)
                    const Center(
                      child: Text(
                        'No hay canciones disponibles.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: songList.length,
                      itemBuilder: (context, index) {
                        final song = songList[index];

                        return SongCard(
                          title: song.title,
                          image: song.imagePath,
                          onTap: () {
                            playSongAt(index);
                          },
                        );
                      },
                    ),

                  // Pestaña de listas.
                  const ListasScreen(),
                ],
              ),
            ),

            // Reproductor inferior.
            const MiniPlayerWidget(),
          ],
        ),
      ),
    );
  }
}

// Tarjeta individual de cada canción.
class SongCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const SongCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF3F3268).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
