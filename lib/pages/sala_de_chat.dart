//import 'dart:convert';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logisticsgame/models/arquivo.dart';
//import 'package:logisticsgame/models/arquivo.dart';
import 'package:logisticsgame/pages/chat_message.dart';

import 'package:logisticsgame/pages/text_composer.dart';

class SalaDeChat extends StatefulWidget {
  final String title;
  final String idEmpresa;

  const SalaDeChat(this.title, this.idEmpresa);
  @override
  _SalaDeChatState createState() => _SalaDeChatState();
}

class _SalaDeChatState extends State<SalaDeChat> {
  bool mine;
  Map mapa;

  @override
  void initState() {
    var arquivo = Arquivo();
    arquivo.readFile().then((data){
      mapa = json.decode(data);
    });
    super.initState();
  }

  void _sendMessage(String text) {
    Firestore.instance.collection('empresas').document('${widget.idEmpresa}').collection('mensagens').add({
      'from': mapa['nome'],
      'text': text,
      'token': mapa['user_id'],
      'time': Timestamp.now(),
    });
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
                                return ChatMessage(mapa['user_id'] == documents[index].data['token'], documents[index].data);
                              },
                            );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextComposer(_sendMessage),
                ],
              ),
            ),

            //Segunda Tela
            Container(),
          ]
        ),
      ),
    );
  }
}