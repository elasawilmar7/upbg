import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logisticsgame/models/listamensagem.dart';

String titulo = "";
String texto = "";

class Mensagens extends StatefulWidget {
  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  bool erro = true;
  var listaMensagem = new List<Mensagem>();

  Future<List<Mensagem>> _getListMensagem() async {
    try {
      var response = await http
          .get('http://elasalearning.com.br/logisticsgame/api_msgs.php');
      Iterable list = json.decode(response.body);
      listaMensagem = list.map((model) => Mensagem.fromJson(model)).toList();
      return listaMensagem;
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
          title: Text('Mensagens',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
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
      /*appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 124, 195, 0.7),
        title: Text(
          'Mensagens',
        ),
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
      ),*/
      body: Container(
        padding: EdgeInsets.all(10),
        child: erro
            ? FutureBuilder(
                future: _getListMensagem(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.data != null) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return ListView.builder(
                      itemCount: listaMensagem.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(listaMensagem[index].title),
                            leading: Icon(
                              Icons.message,
                              color: Colors.green,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisualizarMensagem()),
                              );
                              titulo = listaMensagem[index].title;
                              texto = listaMensagem[index].text;
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

class VisualizarMensagem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Text(
          texto,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
