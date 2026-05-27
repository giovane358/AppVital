// lib/features/user/history/user_history_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────────────────────────────────────

abstract class UserHistoryEvent {}

class StartUserHistory extends UserHistoryEvent {}

// ─────────────────────────────────────────────────────────────────────────────
// STATES
// ─────────────────────────────────────────────────────────────────────────────

abstract class UserHistoryState {}

class UserHistoryLoading extends UserHistoryState {}

class UserHistoryLoaded extends UserHistoryState {
  final List<OcorrenciaModel> ocorrencias;
  UserHistoryLoaded({required this.ocorrencias});
}

class UserHistoryEmpty extends UserHistoryState {}

class UserHistoryError extends UserHistoryState {}

// ─────────────────────────────────────────────────────────────────────────────
// BLOC
// ─────────────────────────────────────────────────────────────────────────────

class UserHistoryBloc extends Bloc<UserHistoryEvent, UserHistoryState> {
  UserHistoryBloc() : super(UserHistoryLoading()) {
    on<StartUserHistory>(_onStartUserHistory);
  }

  Future<void> _onStartUserHistory(
      StartUserHistory event,
      Emitter<UserHistoryState> emit,
      ) async {
    // Substituir por repositório real quando disponível
    await Future.delayed(const Duration(milliseconds: 600));
    final lista = [
      OcorrenciaModel.fromJson({
        'id': 'INC-2024-001',
        'titulo': 'Acidente de Trânsito',
        'local': 'Av. Paulista, 1000',
        'descricao': 'Colisão entre dois veículos com vítimas.',
        'nivel': 'Alta',
        'status': 'concluida',
        'data': '15/01/2024',
        'unidade': 'Unidade A-12',
      }),
      OcorrenciaModel.fromJson({
        'id': 'INC-2023-089',
        'titulo': 'Incêndio Residencial',
        'local': 'Rua das Flores, 45',
        'descricao': 'Fogo no segundo andar.',
        'nivel': 'Alta',
        'status': 'concluida',
        'data': '03/11/2023',
        'unidade': 'Unidade B-03',
      }),
      OcorrenciaModel.fromJson({
        'id': 'INC-2023-041',
        'titulo': 'Mal Súbito',
        'local': 'Praça da Sé, s/n',
        'descricao': 'Pessoa desmaiada na praça.',
        'nivel': 'Média',
        'status': 'concluida',
        'data': '22/07/2023',
        'unidade': null,
      }),
    ];
    emit(lista.isEmpty
        ? UserHistoryEmpty()
        : UserHistoryLoaded(ocorrencias: lista));
  }
}