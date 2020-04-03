class Mensagem {
  int id;
  String title;
  String text;

  Mensagem(int id, String title, String text) {
    this.id = id;
    this.title = title;
    this.text = text;
  }

  Mensagem.fromJson(Map json)
      : id = json['id'],
        title = json['titulo'],
        text = json['texto'];

  Map toJson() {
    return {'id': id, 'titulo': title, 'texto': text};
  }
}
