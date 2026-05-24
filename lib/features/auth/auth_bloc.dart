import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/repository/auth_repository.dart';

// Eventos
abstract class AuthEvent {}

class AuthLoginStart extends AuthEvent {
  final String email;
  final String password;
  AuthLoginStart({required this.email, required this.password});
}

class AuthLoginRetried extends AuthEvent {}

class AuthRegisterStart extends AuthEvent {
  final String name;
  final String cpf;
  final String telefone;
  final String email;
  final String password;

  AuthRegisterStart({
    required this.name,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.password,
  });
}

class AuthRegisterRetried extends AuthEvent {}

// States
abstract class AuthState {}

class AuthIdle extends AuthEvent {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginFailed extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthRegistroFailed extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // credencias
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthLoading()) {
    on<AuthLoginStart>(_checkLogin);
    on<AuthRegisterStart>(_checkRegister);
  }

  Future<void> _checkLogin(
    AuthLoginStart event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      repository.login(email: event.email, senha: event.password);

      print('Login bem-sucedido');

      emit(AuthLoginSuccess());
    } catch (e) {
      emit(AuthLoginFailed());
    }
  }

  Future<void> _checkRegister(
    AuthRegisterStart event,
    Emitter<AuthState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      await repository.register(
        nome: event.name,
        cpf: event.cpf,
        phone: event.telefone,
        email: event.email,
        senha: event.password,
      );
      print('Registro bem-sucedido');
      emit(AuthRegisterSuccess());
    } catch (e) {
      print('Erro no registro: $e');
      emit(AuthRegistroFailed());
    }
  }
}
