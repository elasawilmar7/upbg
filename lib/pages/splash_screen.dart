import 'dart:convert';
import 'dart:io';

import 'package:logisticsgame/models/arquivo.dart';
import 'package:flutter/material.dart';
import 'package:logisticsgame/pages/home_page.dart';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map mapa;

  @override
  void initState() {
    super.initState();
    //var arquivo = Arquivo();

    //arquivo.local = "dados.json";
    //arquivo.readFile().then((data){
    //mapa = json.decode(data);
    checkFile();
    //});
  }

  // Verifica se o Arquivo Existe
  Future<void> checkFile() async {
    var dir = await getApplicationDocumentsDirectory();
    var path = "${dir.path}/dados.json";
    Map a;

    var arquivo = Arquivo();
    //arquivo.local = "dados.json";

    // Se Existir ele lê e Navega para as Telas
    if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
      arquivo.readFile().then((data) {
        a = json.decode(data);

        if (a != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage(a)));
        } else {
          Navigator.pushReplacementNamed(context, '/loginPage');
        }
      });
    } else {
      Navigator.pushReplacementNamed(context, '/loginPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
