import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:untitled/utils/utils.dart';
import 'package:path/path.dart' as path;

import 'audio_file.dart';

class FilesController extends GetxController {
  final audioFiles = [].obs;
  final audioLength = [].obs;
  RxInt playedIndex = 999.obs;

  Future<void> getFiles(String path) async {}

  Future<void> addToAlbum(String filePath, String fileName) async {
    if (File(filePath).existsSync()) {}

    var dir = await getApplicationDocumentsDirectory();
    File(filePath).copySync('${dir.path}/$fileName.mp3');
    if (File('${dir.path}/$fileName').existsSync()) {
    } else {}
  }
}
