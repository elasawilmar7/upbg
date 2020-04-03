import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logisticsgame/models/users.dart';

class LoginApi{
  static Future<Users> login(String id, String user,  String password) async {

    var url = "http://adm.logisticsgame.com.br/api/v1/users?password=$password&email=$user&id=$id";

    var response = await http.get(url);
    
    Map mapResponse = json.decode(response.body);
    mapResponse['id'] = id;
    mapResponse['email'] = user;
    mapResponse['senha'] = password;

    var usuario;

    if (mapResponse["erro"] == null) {

      usuario = Users.fromJson(mapResponse); 

    } else {
      usuario = null;
    }
    
    return usuario;
  }
}