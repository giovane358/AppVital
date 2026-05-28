import 'package:dio/dio.dart';

class AuthService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));

  Future<Response> login({required String email, required String senha}) async {
    return await dio.post(
      '/auth/login',
      data: {'email': email, 'senha': senha},
    );
  }

  Future<Response> register({
    required String nome,
    required String cpf,
    required String phone,
    required String email,
    required String senha,
    required int roleID,
  }) async {
    return await dio.post(
      '/auth/register',
      data: {
        'nome': nome,
        'cpf': cpf,
        'phone': phone,
        'email': email,
        'senha': senha,
        'roleID': roleID,
      },
    );
  }
}
