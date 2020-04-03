import 'dart:io';
import 'dart:convert';
import 'package:logisticsgame/models/listapdf.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:flutter/foundation.dart';

String urlPdf = "";
String titulo = "";

class Materialpdf2 extends StatefulWidget {
  @override
  _MaterialpdfState createState() => _MaterialpdfState();
}

class _MaterialpdfState extends State<Materialpdf2> {
  String pdfurl = "";
  bool erro = true;
  var listaPdf = new List<Pdf>();

  Future<List<Pdf>> _getPdf() async {
    try {
      var response = await http
          .get('http://elasalearning.com.br/logisticsgame/api_pdfs.php');
      Iterable list = json.decode(response.body);
      listaPdf = list.map((model) => Pdf.fromJson(model)).toList();
      return listaPdf;
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
          title: Text('Materiais de Apoio - PDFs',
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
          'Materiais de Apoio - PDFs',
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
                future: _getPdf(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.data != null) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return ListView.builder(
                      itemCount: listaPdf.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(listaPdf[index].title),
                            leading: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfViewPage(
                                          path: listaPdf[index].url)));
                              titulo = listaPdf[index].title;
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

class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({Key key, this.path}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool pdfReady = false;
  bool erro = true;
  Future<String> downloadedFilePath;
  Future<String> _baixarPdf;

  @override
  void initState() {
    super.initState();
    _baixarPdf = baixarpdf();
  }

  Future<String> baixarpdf() async {
    Future<String> origem;
    origem = downloadPdfFile(widget.path);
    setState(() {
      downloadedFilePath = origem;
    });
    return origem;
  }

  Future<String> downloadPdfFile(String url) async {
    try {
      final filename = "arquivodownload.pdf";
      String dir = (await getTemporaryDirectory()).path;
      File file = new File('$dir/$filename');

      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);

      return file.path;
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
      appBar: AppBar(
        title: Text(titulo),
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
      body: erro
          ? FutureBuilder<String>(
              future: _baixarPdf,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return Container(
                    child: Stack(
                      children: <Widget>[
                        PdfViewer(
                          filePath: snapshot.data,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : Center(
              child: Text(
                'Este arquivo PDF esta com problemas, ou sua conexão de internet falhou',
                style: TextStyle(fontSize: 15),
              ),
            ),
    );
  }
}
