// lib/features/user/menu/user_menu_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────────────────────────────────────

abstract class UserMenuEvent {
  const UserMenuEvent();
}

class StartUserMenu extends UserMenuEvent {
  /// Nome do utilizador autenticado — virá do SharedPreferences/auth futuramente.
  final String userName;
  const StartUserMenu({required this.userName});
}

// ─────────────────────────────────────────────────────────────────────────────
// STATES
// ─────────────────────────────────────────────────────────────────────────────

abstract class UserMenuState {}

class UserMenuLoading extends UserMenuState {}

class UserMenuReady extends UserMenuState {
  final String userName;
  final bool hasActiveOccurrence;

  UserMenuReady({
    required this.userName,
    required this.hasActiveOccurrence,
  });
}

class UserMenuError extends UserMenuState {}

// ─────────────────────────────────────────────────────────────────────────────
// BLOC
// ─────────────────────────────────────────────────────────────────────────────

class UserMenuBloc extends Bloc<UserMenuEvent, UserMenuState> {
  UserMenuBloc() : super(UserMenuLoading()) {
    on<StartUserMenu>(_onStartUserMenu);
  }

  Future<void> _onStartUserMenu(
      StartUserMenu event,
      Emitter<UserMenuState> emit,
      ) async {
    // Simula verificação de ocorrência ativa (substituir por repositório real)
    await Future.delayed(const Duration(milliseconds: 600));
    emit(UserMenuReady(
      userName: event.userName,
      hasActiveOccurrence: true, // Mock — INC-2024-001
    ));
  }
}