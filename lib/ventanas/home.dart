import 'package:flowing_music/elementos/canciones_ui.dart';
import 'package:flowing_music/elementos/mini_player.dart';
import 'package:flowing_music/reproductor/service_musica.dart';
import 'package:flowing_music/reproductor/canciones_model.dart';

import '../elementos/mini_player.dart';
import 'reproductor.dart';

import 'package:material_ui/material_ui.dart';

import '../elementos/texto.dart';
import '../ajustes.dart';
import '../temas/colores.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ServiceMusica _serviceMusica = ServiceMusica();
  List<Cancion> _canciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarCanciones();

    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _cargarCanciones() async {
    setState(() {
      _isLoading = true;
    });
    _canciones = await _serviceMusica.scanCancion();

    setState(() {
      _isLoading = false;
    });
  }

  void _tapCancion(int idx) async {
    _serviceMusica.play(idx);
    setState(() {});
  }

  void _reproductorOpen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Reproductor()),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Flowing Music",
          style: TextStyle(
            fontFamily: 'RussoOne',
            fontSize: 30,
            decoration: TextDecoration.underline,
            color: lila,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: azul),
            onPressed: _cargarCanciones,
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: azul),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AjustesScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
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
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: azul),
                          SizedBox(height: 16),
                          Text(
                            'Buscando archivos de música...',
                            style: txtStyle(),
                          ),
                        ],
                      ),
                    )
                  : _canciones.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_off, size: 80, color: lila),
                          SizedBox(height: 16),
                          Text(
                            'No se encontraron canciones.',
                            style: txtStyle(color: rosaOsc),
                          ),
                          SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: _cargarCanciones,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: moradoP,
                              //foregroundColor: negro,
                            ),
                            child: Text('Buscar de nuevo', style: txtStyle()),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _canciones.length,
                      itemBuilder: (context, idx) {
                        return SongTile(
                          cancion: _canciones[idx],
                          isPlaying: _serviceMusica.currentIndex == idx,
                          onTap: () => _tapCancion(idx),
                        );
                      },
                    ),
            ),
            if (_serviceMusica.cancionAct != null)
              MiniPlyr(
                onTap: () => _reproductorOpen(context),
                pause: () async {
                  await _serviceMusica.pause;
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }
}
