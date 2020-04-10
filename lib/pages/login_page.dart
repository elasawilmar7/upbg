import 'dart:async';
import 'dart:convert';
//import 'dart:typed_data';

//import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:logisticsgame/models/arquivo.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_api.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _ctrlId = TextEditingController();
  final _ctrlLogin = TextEditingController();
  final _ctrlSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String barcode = "";
  bool isLoading = false;

  @override
  //  void initState() {
  //    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //  super.initState();
  //}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color.fromRGBO(1, 125, 199, 1),
              Color.fromRGBO(1, 83, 131, 1)
            ])),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Image.asset(
                      "imagens/logo.png",
                      scale: 1.2,
                    ),
                    SizedBox(height: 15),
                    _textFormField(
                      "ID",
                      "Digite o ID",
                      validator: _valida,
                      controller: _ctrlId,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10),
                    _textFormField(
                      "Login",
                      "Digite seu Login",
                      validator: _valida,
                      controller: _ctrlLogin,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    _textFormField(
                      "Senha",
                      "Digite sua Senha",
                      senha: true,
                      validator: _valida,
                      controller: _ctrlSenha,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 30),
                    _flatButton("Entrar", context),
                    SizedBox(height: 15),
                    IconButton(
                        icon: Icon(MdiIcons.qrcode),
                        iconSize: 40,
                        color: Color.fromRGBO(255, 197, 1, 1),
                        onPressed: () {
                          _scan();
                        }),
                    Text(
                      barcode,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              isLoading ? LinearProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),) : Container(),
            ],
          )
        ),
      ),
    );
  }

  // Validação dos Campos
  String _valida(String texto) {
    if (texto.isEmpty) {
      return "Campo Vazio";
    }
    return null;
  }

  // Modelo do TextFormField
  _textFormField(
    String label,
    String hint, {
    labelSize = 10.0,
    hintSize = 10.0,
    bool senha = false,
    Color fillColor = Colors.white,
    Color hintColor = Colors.black54,
    Color labelColor = Colors.black54,
    TextEditingController controller,
    FormFieldValidator<String> validator,
    TextInputType keyboardType,
  }) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: fillColor, width: 2.0),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: senha,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: labelColor,
            fontSize: labelSize,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: hintSize,
          ),
          filled: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Botão de Login
  _flatButton(
    String label,
    context,
  ) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 197, 1, 1),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          )),
      child: FlatButton(
        child: Stack(
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.blue[800],
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            )
          ],
        ),
        onPressed: () {
          isLoading = true;
          _clickButton(context);
        },
      ),
    );
  }

  // Ação do Botão
  Future _clickButton(BuildContext context) async {
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }

    String id = _ctrlId.text;
    String login = _ctrlLogin.text;
    String senha = _ctrlSenha.text;

    _verificacao(id, login, senha, save: true);
  }

  // Validação do Usuário
  _verificacao(id, login, senha, {save = false}) async {
    var arquivo = Arquivo();
    //var arquivo2 = Arquivo();
    var usuario = await LoginApi.login(id, login, senha);

    //Map<String, dynamic> mapaLogin = Map();
    //mapaLogin["id"] = id;
    //mapaLogin["login"] = login;
    //mapaLogin["senha"] = senha;

    if (usuario != null) {
      arquivo.readFile().then((data) {
        var mapa = json.decode(data);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage(mapa)));
      });
      if (save == true) {
        Map mapaUser = usuario.toJson();
        arquivo.mapa = mapaUser;
        //arquivo.local = "dados.json";
        arquivo.saveFile();

        //arquivo2.mapa = mapaLogin;
        //arquivo2.local = "login.json";
        //arquivo2.saveFile();
      }
    } else {
      alert(context, "Login Inválido!");
    }
  }

  // Alerta Login Inválido
  alert(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    //setState(() => this.barcode = barcode);
    var mapa = json.decode(barcode);
    var id = mapa['id'];
    var login = mapa['login'];
    var senha = mapa['senha'];
    _verificacao(id, login, senha, save: true);
  }
} // Final
