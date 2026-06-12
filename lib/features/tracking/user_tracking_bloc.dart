// lib/features/user/tracking/user_tracking_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────────────────────────────────────

abstract class UserTrackingEvent {}

class StartUserTracking extends UserTrackingEvent {}

// ─────────────────────────────────────────────────────────────────────────────
// STATES
// ─────────────────────────────────────────────────────────────────────────────

abstract class UserTrackingState {}

class UserTrackingLoading extends UserTrackingState {}

class UserTrackingLoaded extends UserTrackingState {
  final OcorrenciaModel ocorrencia;
  UserTrackingLoaded({required this.ocorrencia});
}

class UserTrackingEmpty extends UserTrackingState {}

class UserTrackingError extends UserTrackingState {}

// ─────────────────────────────────────────────────────────────────────────────
// BLOC
// ─────────────────────────────────────────────────────────────────────────────

class UserTrackingBloc extends Bloc<UserTrackingEvent, UserTrackingState> {
  UserTrackingBloc() : super(UserTrackingLoading()) {
    on<StartUserTracking>(_onStartUserTracking);
  }

  Future<void> _onStartUserTracking(
      StartUserTracking event,
      Emitter<UserTrackingState> emit,
      ) async {
    // Substituir por repositório real quando disponível
    await Future.delayed(const Duration(milliseconds: 600));
    emit(UserTrackingLoaded(
      ocorrencia: OcorrenciaModel.fromJson({
        'id': 'INC-2024-001',
        'titulo': 'Acidente de Trânsito',
        'local': 'Av. Paulista, 1000 - São Paulo',
        'descricao': 'Colisão entre dois veículos com vítimas.',
        'nivel': 'Alta',
        'status': 'em_atendimento',
        'data': '15/01/2024 às 14:32',
        'unidade': 'Unidade A-12',
      }),
    ));
  }
}