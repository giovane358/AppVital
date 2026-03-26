import 'package:flutter_bloc/flutter_bloc.dart';

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
  static const _validEmail = 'giovane@gmail.com';
  static const _validPass = '123456';

  AuthBloc() : super(AuthLoading()) {
    on<AuthLoginStart>(_checkLogin);
    on<AuthRegisterStart>(_checkRegister);
  }

  Future<void> _checkLogin(
    AuthLoginStart event,
    Emitter<AuthState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final isValid = event.email == _validEmail && event.password == _validPass;
    emit(isValid ? AuthLoginSuccess() : AuthLoginFailed());
  }

  Future<void> _checkRegister(
    AuthRegisterStart event,
    Emitter<AuthState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    emit(AuthRegisterSuccess());
  }
}
