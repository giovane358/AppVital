// lib/features/ops/navigation/ops_navigation_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────────────────────────────────────

abstract class OpsNavigationEvent {}

class StartOpsNavigation extends OpsNavigationEvent {}

class ChegouAoLocal extends OpsNavigationEvent {}

// ─────────────────────────────────────────────────────────────────────────────
// STATES
// ─────────────────────────────────────────────────────────────────────────────

abstract class OpsNavigationState {}

class OpsNavigationLoading extends OpsNavigationState {}

class OpsNavigationLoaded extends OpsNavigationState {
  final OcorrenciaModel ocorrencia;
  final String distancia;
  final String tempoEstimado;

  OpsNavigationLoaded({
    required this.ocorrencia,
    required this.distancia,
    required this.tempoEstimado,
  });
}

class OpsNavigationChegou extends OpsNavigationState {}

class OpsNavigationError extends OpsNavigationState {}

// ─────────────────────────────────────────────────────────────────────────────
// BLOC
// ─────────────────────────────────────────────────────────────────────────────

class OpsNavigationBloc
    extends Bloc<OpsNavigationEvent, OpsNavigationState> {
  OpsNavigationBloc() : super(OpsNavigationLoading()) {
    on<StartOpsNavigation>(_onStart);
    on<ChegouAoLocal>(_onChegou);
  }

  Future<void> _onStart(
      StartOpsNavigation event,
      Emitter<OpsNavigationState> emit,
      ) async {
    // Substituir por GPS/repositório real
    await Future.delayed(const Duration(milliseconds: 600));
    emit(OpsNavigationLoaded(
      ocorrencia: OcorrenciaModel.fromJson({
        'id': 'INC-2024-003',
        'titulo': 'Acidente com Vítimas',
        'local': 'Rua Augusta, 500 - São Paulo',
        'descricao': 'Colisão entre moto e carro.',
        'nivel': 'Alta',
        'status': 'em_atendimento',
        'data': 'Há 5 minutos',
        'unidade': 'Unidade A-12',
      }),
      distancia: '2,3 km',
      tempoEstimado: '7 min',
    ));
  }

  Future<void> _onChegou(
      ChegouAoLocal event,
      Emitter<OpsNavigationState> emit,
      ) async {
    emit(OpsNavigationChegou());
  }
}