import 'dart:convert';

import 'package:logisticsgame/models/arquivo.dart';
import 'package:logisticsgame/models/empresa.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logisticsgame/pages/sala_de_chat.dart';

class Empresas extends StatefulWidget {
  final String title;
  final String id;

  const Empresas({Key key, this.title, this.id}) : super(key: key);

  @override
  _EmpresasState createState() => _EmpresasState();
}

class _EmpresasState extends State<Empresas> {
  bool erro = true;
  List listaEmpresa = new List<Empresa>();
  Map mapa;

  Future<List<Empresa>> _getEmpresa() async {
    var arquivo = Arquivo();
    String data = await arquivo.readFile();
    mapa = json.decode(data);

    try {
      var url =
          "http://adm.logisticsgame.com.br/api/v1/empresas?id=${mapa['id']}&id_simulacao=${widget.id}";
      var response = await http.get(url);
      Iterable list = json.decode(response.body);
      listaEmpresa = list.map((model) => Empresa.fromJson(model)).toList();
      return listaEmpresa;
    } catch (e) {
      setState(() {
        erro = false;
      });
      throw ('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: Text(widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                )),
            leading: FlatButton(
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(50),
            )),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20.0),
          child: erro
              ? FutureBuilder(
                  future: _getEmpresa(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print(snapshot.data);
                    if (snapshot.data != null) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return ListView.builder(
                        itemCount: listaEmpresa.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SalaDeChat(
                                        listaEmpresa[index].name,
                                        listaEmpresa[index].id))),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Card(
                                color: Colors.blue[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  height: 80,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            image: new NetworkImage(
                                                listaEmpresa[index].logo),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          listaEmpresa[index].name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              : Center(
                  child: Text('Sua conexão de internet falhou.',
                      style: TextStyle(fontSize: 15)),
                ),
        ));
  }
}
