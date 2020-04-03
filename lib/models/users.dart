class Users {
  String cliente;
  String nome;
  String userId;
  String perfil;
  String idSimulacao;
  String id;
  String login;
  String senha;
  String companyId;
  String empresa;

  Users(this.cliente, this.nome, this.userId, this.perfil, this.idSimulacao,
      this.id, this.login, this.senha, this.companyId, this.empresa);

  Users.fromJson(Map<String, dynamic> json) {
    cliente = json['cliente'];
    nome = json['nome'];
    userId = json['user_id'];
    perfil = json['perfil'];
    idSimulacao = json['id_simulacao'];
    id = json['id'];
    login = json['login'];
    senha = json['senha'];
    companyId = json['company_id'];
    empresa = json['empresa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cliente'] = this.cliente;
    data['nome'] = this.nome;
    data['user_id'] = this.userId;
    data['perfil'] = this.perfil;
    data['id_simulacao'] = this.idSimulacao;
    data['id'] = this.id;
    data['login'] = this.login;
    data['senha'] = this.senha;
    data['company_id'] = this.companyId;
    data['empresa'] = this.empresa;
    return data;
  }
}
