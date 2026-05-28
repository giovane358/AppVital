// lib/features/ops/assigned/ops_assigned_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────────────────────────────────────

abstract class OpsAssignedEvent {}

class StartOpsAssigned extends OpsAssignedEvent {}

class IniciarNavegacao extends OpsAssignedEvent {}

// ─────────────────────────────────────────────────────────────────────────────
// STATES
// ─────────────────────────────────────────────────────────────────────────────

abstract class OpsAssignedState {}

class OpsAssignedLoading extends OpsAssignedState {}

class OpsAssignedLoaded extends OpsAssignedState {
  final OcorrenciaModel ocorrencia;
  OpsAssignedLoaded({required this.ocorrencia});
}

class OpsAssignedNavigating extends OpsAssignedState {}

class OpsAssignedError extends OpsAssignedState {}

// ─────────────────────────────────────────────────────────────────────────────
// BLOC
// ─────────────────────────────────────────────────────────────────────────────

class OpsAssignedBloc extends Bloc<OpsAssignedEvent, OpsAssignedState> {
  OpsAssignedBloc() : super(OpsAssignedLoading()) {
    on<StartOpsAssigned>(_onStart);
    on<IniciarNavegacao>(_onNavegar);
  }

  Future<void> _onStart(
      StartOpsAssigned event,
      Emitter<OpsAssignedState> emit,
      ) async {
    // Substituir por repositório real
    await Future.delayed(const Duration(milliseconds: 600));
    emit(OpsAssignedLoaded(
      ocorrencia: OcorrenciaModel.fromJson({
        'id': 'INC-2024-003',
        'titulo': 'Acidente com Vítimas',
        'local': 'Rua Augusta, 500 - São Paulo',
        'descricao': 'Colisão entre moto e carro com duas vítimas.',
        'nivel': 'Alta',
        'status': 'em_atendimento',
        'data': 'Há 5 minutos',
        'unidade': 'Unidade A-12',
      }),
    ));
  }

  Future<void> _onNavegar(
      IniciarNavegacao event,
      Emitter<OpsAssignedState> emit,
      ) async {
    emit(OpsAssignedNavigating());
  }
}