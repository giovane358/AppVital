// lib/features/ops/details/ops_incident_details_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────────────────────────────────────

abstract class OpsIncidentDetailsEvent {}

class StartOpsIncidentDetails extends OpsIncidentDetailsEvent {
  final OcorrenciaModel ocorrencia;
  StartOpsIncidentDetails({required this.ocorrencia});
}

class AtribuirOcorrencia extends OpsIncidentDetailsEvent {
  final String ocorrenciaId;
  AtribuirOcorrencia({required this.ocorrenciaId});
}

// ─────────────────────────────────────────────────────────────────────────────
// STATES
// ─────────────────────────────────────────────────────────────────────────────

abstract class OpsIncidentDetailsState {}

class OpsIncidentDetailsLoading extends OpsIncidentDetailsState {}

class OpsIncidentDetailsLoaded extends OpsIncidentDetailsState {
  final OcorrenciaModel ocorrencia;
  OpsIncidentDetailsLoaded({required this.ocorrencia});
}

class OpsIncidentDetailsAtribuindo extends OpsIncidentDetailsState {
  final OcorrenciaModel ocorrencia;
  OpsIncidentDetailsAtribuindo({required this.ocorrencia});
}

class OpsIncidentDetailsAtribuida extends OpsIncidentDetailsState {}

class OpsIncidentDetailsError extends OpsIncidentDetailsState {}

// ─────────────────────────────────────────────────────────────────────────────
// BLOC
// ─────────────────────────────────────────────────────────────────────────────

class OpsIncidentDetailsBloc
    extends Bloc<OpsIncidentDetailsEvent, OpsIncidentDetailsState> {
  OpsIncidentDetailsBloc() : super(OpsIncidentDetailsLoading()) {
    on<StartOpsIncidentDetails>(_onStart);
    on<AtribuirOcorrencia>(_onAtribuir);
  }

  Future<void> _onStart(
      StartOpsIncidentDetails event,
      Emitter<OpsIncidentDetailsState> emit,
      ) async {
    emit(OpsIncidentDetailsLoaded(ocorrencia: event.ocorrencia));
  }

  Future<void> _onAtribuir(
      AtribuirOcorrencia event,
      Emitter<OpsIncidentDetailsState> emit,
      ) async {
    final current = state;
    if (current is OpsIncidentDetailsLoaded) {
      emit(OpsIncidentDetailsAtribuindo(ocorrencia: current.ocorrencia));
      // Substituir por chamada de repositório real
      await Future.delayed(const Duration(seconds: 1));
      emit(OpsIncidentDetailsAtribuida());
    }
  }
}