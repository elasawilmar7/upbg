class Pdf {
  int id;
  String title;
  String url;

  Pdf(int id, String name, String email) {
    this.id = id;
    this.title = title;
    this.url = url;
  }

  Pdf.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        url = json['url'];

  Map toJson() {
    return {'id': id, 'title': title, 'url': url};
  }
}
