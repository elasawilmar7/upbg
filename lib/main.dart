import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'package:logisticsgame/pages/home_page.dart';
import 'package:logisticsgame/pages/jogo_da_velha.dart';
import 'package:logisticsgame/pages/login_page.dart';
import 'package:logisticsgame/pages/material_pdf.dart';
import 'package:logisticsgame/pages/material_video.dart';
import 'package:logisticsgame/pages/mensagem.dart';
import 'package:logisticsgame/pages/simulacoes.dart';
import 'package:logisticsgame/pages/splash_screen.dart';


void main() async{
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LogisticsGames',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.blue,
        )
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => SplashScreen(),
        '/loginPage' : (context) => LoginPage(),
        '/simulacao' : (context) => Simulacoes(),
        '/mensagem' : (context) => Mensagens(),
        '/pdf' : (context) => Materialpdf2(),
        '/video' : (context) => Materialvideos(),
        '/velha' : (context) => JogoDaVelha(),
      },
    );
  }
}