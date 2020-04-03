class Video {
  int id;
  String title;
  String url;

  Video(int id, String name, String url) {
    this.id = id;
    this.title = title;
    this.url = url;
  }

  Video.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        url = json['url'];

  Map toJson() {
    return {'id': id, 'title': title, 'url': url};
  }
}
