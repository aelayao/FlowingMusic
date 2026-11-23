import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ventanas/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();

  runApp(const FlowingMusicApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.storage,
    Permission.manageExternalStorage,
    Permission.audio,
  ].request();
}
