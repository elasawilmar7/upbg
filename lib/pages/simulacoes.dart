import 'dart:convert';

import 'package:logisticsgame/models/arquivo.dart';
import 'package:logisticsgame/models/simulacao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'empresas.dart';

class Simulacoes extends StatefulWidget {
  @override
  _SimulacoesState createState() => _SimulacoesState();
}

class _SimulacoesState extends State<Simulacoes> {
  String titulo;
  bool erro = true;
  var listaSimulacao = new List<Simulacao>();

  Future<List<Simulacao>> _getSimulacao() async {
    var arquivo = Arquivo();
    //var arquivo2 = Arquivo();

    //arquivo.local = "dados.json";
    //arquivo2.local = "login.json";

    String data = await arquivo.readFile();
    Map mapa = json.decode(data);

    //String data2 = await arquivo2.readFile();
    //Map mapa2 = json.decode(data2);

    try {
      var url =
          'http://adm.logisticsgame.com.br/api/v1/simulacoes?id=${mapa['id']}&perfil=${mapa['perfil']}&simulation_id=${mapa['id_simulacao']}&user_id=${mapa['user_id']}';
      var response = await http.get(url);
      Iterable list = json.decode(response.body);
      listaSimulacao = list.map((model) => Simulacao.fromJson(model)).toList();
      return listaSimulacao;
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
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: Text('Simulações',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              )),
          leading: FlatButton(
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
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
      /*appBar: AppBar(
        title: Text('Simulações'),
        leading: FlatButton(
            child: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),*/
      body: Container(
        padding: EdgeInsets.all(10),
        child: erro
            ? FutureBuilder(
                future: _getSimulacao(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.data != null) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return ListView.builder(
                      itemCount: listaSimulacao.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(listaSimulacao[index].name),
                            subtitle: Text(
                                'Quantidade de empresas: ${listaSimulacao[index].numberOfCompany}'),
                            leading: Icon(
                              Icons.book,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Empresas(
                                          title: listaSimulacao[index].name,
                                          id: listaSimulacao[index].id,
                                        )),
                              );
                            },
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
      ),
    );
  }
}
