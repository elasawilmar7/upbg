import 'dart:convert';
//import 'package:flutter/services.dart';
import 'package:logisticsgame/models/listavideo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:webview_flutter/webview_flutter.dart';

String urlPdf = "";
String titulo = "";

class Materialvideos extends StatefulWidget {
  @override
  _MaterialpdfState createState() => _MaterialpdfState();
}

class _MaterialpdfState extends State<Materialvideos> {
  String pdfurl = "";
  bool erro = true;
  var listaVideo = new List<Video>();

  Future<List<Video>> _getListVideo() async {
    try {
      var response = await http
          .get('http://elasalearning.com.br/logisticsgame/api_videos.php');
      Iterable list = json.decode(response.body);
      listaVideo = list.map((model) => Video.fromJson(model)).toList();
      return listaVideo;
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
          title: Text('Materiais de Apoio - Vídeos',
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
          'Materiais de Apoio - Vídeos',
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
                future: _getListVideo(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.data != null) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return ListView.builder(
                      itemCount: listaVideo.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(listaVideo[index].title),
                            leading: Icon(
                              Icons.video_library,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Youtube(
                                          url: listaVideo[index].url,
                                          title: listaVideo[index].title,
                                        )),
                              );
                              //FlutterYoutube.playYoutubeVideoByUrl(
                              //    apiKey: "<API_KEY>",
                              //    autoPlay: true,
                              //    videoUrl: listaVideo[index].url);
                              //titulo = listaVideo[index].title;
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

class Youtube extends StatefulWidget {
  final String url;
  final String title;

  const Youtube({Key key, this.url, this.title}) : super(key: key);
  @override
  _YoutubeState createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  @override
  //void initState() {
  //  SystemChrome.setPreferredOrientations([
  //  DeviceOrientation.portraitUp,
  //  DeviceOrientation.landscapeLeft,
  //  DeviceOrientation.landscapeRight,
  //]);
  //super.initState();
  //}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        leading: FlatButton(
            child: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            initialUrl:
                'https://elasalearning.com.br/logisticsgame/api_play.php?video=${widget.url}',
            javascriptMode: JavascriptMode.unrestricted,
          );
        },
      ),
    );
  }
}
