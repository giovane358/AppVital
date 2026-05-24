import 'package:vital_application/core/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  Future<void> login({required String email, required String senha}) async {
    try {
      final response = await authService.login(email: email, senha: senha);

      final token = response.data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', token);

        return;
      } else {
        throw Exception('Falha no login: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erro ao tentar logar: $e');
    }
  }

  Future<void> register({
    required String nome,
    required String email,
    required String senha,
    required String cpf,
    required String phone,
  }) async {
    try {
      final response = await authService.register(
        nome: nome,
        cpf: cpf,
        email: email,
        phone: phone,
        senha: senha,
        roleID: 2,
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Falha no registro: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erro ao tentar registrar: $e');
    }
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    return !JwtDecoder.isExpired(token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('token')) {
      await prefs.remove('token');
    } else {
      throw Exception('Nenhum token encontrado para logout.');
    }
  }
}


//await authRepository.logout();

