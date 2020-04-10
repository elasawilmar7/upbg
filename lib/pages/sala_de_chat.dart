import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logisticsgame/models/alunos.dart';
import 'package:logisticsgame/pages/chat_message.dart';

import 'package:logisticsgame/pages/text_composer.dart';

class SalaDeChat extends StatefulWidget {
  final String title;
  final String idEmpresa;
  final Map mapa;

  const SalaDeChat(this.title, this.idEmpresa, this.mapa);
  @override
  _SalaDeChatState createState() => _SalaDeChatState();
}

class _SalaDeChatState extends State<SalaDeChat> {
  bool isLoading = false;
  var listaAluno = new List<Aluno>();

  void _sendMessage({String text, File imgFile}) async{

    Map<String, dynamic> data = {};
      data['from'] = widget.mapa['nome'];
      data['token'] = widget.mapa['user_id'];
      data['time'] = Timestamp.now();

    if(imgFile != null) {
      print(imgFile);
      StorageUploadTask task = FirebaseStorage.instance.ref().child('image').child(
        DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgFile);

      setState(() {
        isLoading = true;
      });

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      print(url);
      data['imgFile'] = url;

      setState(() {
        isLoading = false;
      });
    }
    if(text != null) {
      data['text'] = text;
    }
    Firestore.instance.collection('empresas').document('${widget.idEmpresa}').collection('mensagens').add(data);
  }

  Future<List<Aluno>> _getAluno() async {
    try {
      var response = await http
          .get('http://adm.logisticsgame.com.br/api/v1/alunos?id=teste&id_simulacao=${widget.mapa['id_simulacao']}&company_id=${widget.mapa['company_id']}');
      Iterable list = json.decode(response.body);
      listaAluno = list.map((model) => Aluno.fromJson(model)).toList();
      return listaAluno;
    } catch (e) {
      throw ('');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.message)),
              Tab(icon: Icon(Icons.account_circle)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //Primeira Tela
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('empresas').document('${widget.idEmpresa}').collection('mensagens').orderBy('time').snapshots(),
                      builder: (context, snapshot){
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          default: 
                            List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();
                            return ListView.builder(
                              itemCount: documents.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                return ChatMessage(widget.mapa['user_id'] == documents[index].data['token'], documents[index].data);
                              },
                            );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading ? LinearProgressIndicator() : Container(),
                  TextComposer(_sendMessage),
                ],
              ),
            ),

            //Segunda Tela
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: FutureBuilder(
                future: _getAluno(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.data != null) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return ListView.builder(
                      itemCount: listaAluno.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(listaAluno[index].name),
                            leading: Icon(
                              Icons.account_circle,
                              color: Colors.blue,
                            ),
                            onTap: () {
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
              ),
            ),
          ]
        ),
      ),
    );
  }
}