import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JogoDaVelha extends StatefulWidget {
  @override
  _JogoDaVelhaState createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 124, 195, 0.7),
        title: Text("Jogo da Velha"),
        centerTitle: true,
        leading: FlatButton(
          child: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            initialUrl:
                'http://elasalearning.com.br/logisticsgame/jogodavelha/jv2.php',
            javascriptMode: JavascriptMode.unrestricted,
          );
        },
      ),
    );
  }
}
