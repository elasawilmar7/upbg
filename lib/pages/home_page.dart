import 'package:logisticsgame/models/arquivo.dart';
import 'package:flutter/material.dart';
import 'package:logisticsgame/pages/sala_de_chat.dart';

class HomePage extends StatefulWidget {
  final Map mapa;

  HomePage(this.mapa);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text('LogisticsGame'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          )),
        ),
      ),
      body: Container(
          alignment: Alignment.center,
          child: SizedBox(
            child: Image.asset('imagens/logo.png'),
            width: 250,
          )),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: new DecorationImage(
                  image: new ExactAssetImage('imagens/logo.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.grey,
                    BlendMode.exclusion,
                  ),
                ),
              ),
              accountName: Text(
                widget.mapa['nome'],
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                widget.mapa['cliente'],
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),

              //currentAccountPicture: CircleAvatar(),
            ),
            widget.mapa['perfil'] == 'coordinator'
                ? _listTile(
                    "Simulações",
                    Icons.assignment,
                    '/simulacao',
                  )
                : ListTile(
                    title: Text('Sala de Chat'),
                    leading: Icon(Icons.chat),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalaDeChat(
                                'Chat', widget.mapa['company_id'])))),
            _listTile(
              "Mensagens",
              Icons.message,
              '/mensagem',
            ),
            _listTile(
              "Material PDF",
              Icons.picture_as_pdf,
              '/pdf',
            ),
            _listTile(
              "Material Video",
              Icons.video_library,
              '/video',
            ),
            _listTile(
              "Jogo da Velha",
              Icons.apps,
              '/velha',
            ),
            _listTile(
              "Sair (LogOut)",
              Icons.arrow_back,
              '/loginPage',
              save: true,
            ),
          ],
        ),
      ),
    );
  }

  _listTile(String nome, icon, String rota, {save = false}) {
    return ListTile(
      title: Text(nome),
      leading: Icon(
        icon,
        color: Colors.blue,
      ),
      onTap: () {
        Navigator.pushNamed(context, rota);
        if (save) {
          var arquivo = Arquivo();
          //arquivo.local = "login.json";
          arquivo.saveFile();
        }
      },
    );
  }
} // final
