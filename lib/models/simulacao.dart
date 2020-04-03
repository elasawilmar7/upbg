class Simulacao {
  String name;
  String id;
  int numberOfCompany;

  Simulacao({this.name, this.id, this.numberOfCompany});

  Simulacao.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    numberOfCompany = json['number_of_company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['number_of_company'] = this.numberOfCompany;
    return data;
  }
}
