import 'package:flowing_music/temas/tema_osc.dart';

import 'home.dart';

import 'package:material_ui/material_ui.dart';

class FlowingMusicApp extends StatelessWidget {
  const FlowingMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flowing Music',
      debugShowCheckedModeBanner: false,
      theme: modoOscuro,
      home: const HomeScreen(),
    );
  }
}
