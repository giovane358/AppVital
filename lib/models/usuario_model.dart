class UsuarioModel {
  final String nome;
  final String email;
  final String token;

  UsuarioModel({required this.nome, required this.email, required this.token});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      nome: json['nome'],
      email: json['email'],
      token: json['token'],
    );
  }
}
