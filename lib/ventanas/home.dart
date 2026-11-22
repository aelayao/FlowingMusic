import 'package:flowing_music/reproductor/service_musica.dart';
import 'package:flowing_music/reproductor/canciones_model.dart';

import 'reproductor.dart';

import 'package:get/get.dart';
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

    void _tapCancion(int index) async {
      await _serviceMusica.play(index);
      setState(() {});

      void _reproductorOpen() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Reproductor()),
        );
      }
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
            /*Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Flowing Music",
                    style: TextStyle(
                      fontFamily: 'RussoOne',
                      fontSize: 30,
                      decoration: TextDecoration.underline,
                      color: lila,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: azul),
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
            ),*/
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
            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text("Nombre Canción", style: txtStyle()),
                      subtitle: Text("Artista", style: txtStyle(size: 16)),
                      leading: const Icon(
                        Icons.diamond,
                        color: rosaClr,
                        size: 32,
                      ),
                      trailing: Text("3:00", style: txtStyle()),
                    ),
                  );
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
