// lib/features/ops/dashboard/ops_dashboard_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────────────────────────────────────

abstract class OpsDashboardEvent {}

class StartOpsDashboard extends OpsDashboardEvent {}

// ─────────────────────────────────────────────────────────────────────────────
// STATES
// ─────────────────────────────────────────────────────────────────────────────

abstract class OpsDashboardState {}

class OpsDashboardLoading extends OpsDashboardState {}

class OpsDashboardLoaded extends OpsDashboardState {
  final List<OcorrenciaModel> novas;
  final int totalAtivas;
  final int totalConcluidas;

  OpsDashboardLoaded({
    required this.novas,
    required this.totalAtivas,
    required this.totalConcluidas,
  });
}

class OpsDashboardError extends OpsDashboardState {}

// ─────────────────────────────────────────────────────────────────────────────
// BLOC
// ─────────────────────────────────────────────────────────────────────────────

class OpsDashboardBloc extends Bloc<OpsDashboardEvent, OpsDashboardState> {
  OpsDashboardBloc() : super(OpsDashboardLoading()) {
    on<StartOpsDashboard>(_onStartOpsDashboard);
  }

  Future<void> _onStartOpsDashboard(
      StartOpsDashboard event,
      Emitter<OpsDashboardState> emit,
      ) async {
    // Substituir por repositório real quando disponível
    await Future.delayed(const Duration(milliseconds: 600));
    final novas = [
      OcorrenciaModel.fromJson({
        'id': 'INC-2024-003',
        'titulo': 'Acidente com Vítimas',
        'local': 'Rua Augusta, 500 - São Paulo',
        'descricao': 'Colisão entre moto e carro.',
        'nivel': 'Alta',
        'status': 'aguardando',
        'data': 'Há 3 minutos',
        'unidade': null,
      }),
      OcorrenciaModel.fromJson({
        'id': 'INC-2024-002',
        'titulo': 'Princípio de Incêndio',
        'local': 'Av. Brigadeiro Faria Lima, 200',
        'descricao': 'Fumaça saindo do terceiro andar.',
        'nivel': 'Média',
        'status': 'aguardando',
        'data': 'Há 12 minutos',
        'unidade': null,
      }),
    ];
    emit(OpsDashboardLoaded(
      novas: novas,
      totalAtivas: 4,
      totalConcluidas: 17,
    ));
  }
}