import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class Arquivo {
  Map mapa;
  //String local;

  Arquivo({this.mapa});

  Future<File> getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/dados.json");
  }

  Future<File> saveFile() async{
      final data = json.encode(this.mapa);
      final file = await getFile();
      return file.writeAsString(data);
  }

  Future<String> readFile() async{
    final file = await getFile();
    return file.readAsString();
  }
}