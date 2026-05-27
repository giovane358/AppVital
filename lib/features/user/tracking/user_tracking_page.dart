// lib/features/user/tracking/user_tracking_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/features/user/tracking/user_tracking_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────

class UserTrackingPage extends StatelessWidget {
  const UserTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserTrackingBloc()..add(StartUserTracking()),
      child: const _UserTrackingView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _UserTrackingView extends StatelessWidget {
  const _UserTrackingView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserTrackingBloc, UserTrackingState>(
      listener: (context, state) {
        if (state is UserTrackingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao carregar ocorrência.')),
          );
        }
      },
      child: const _UserTrackingScaffold(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCAFFOLD
// ─────────────────────────────────────────────────────────────────────────────

class _UserTrackingScaffold extends StatelessWidget {
  const _UserTrackingScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        title: const Text(
          'Acompanhamento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.colorButtonRed,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<UserTrackingBloc, UserTrackingState>(
        builder: (context, state) {
          if (state is UserTrackingLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.colorButtonRed),
            );
          }
          if (state is UserTrackingEmpty) {
            return const _TrackingEmpty();
          }
          if (state is UserTrackingLoaded) {
            return _TrackingContent(ocorrencia: state.ocorrencia);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ESTADO VAZIO
// ─────────────────────────────────────────────────────────────────────────────

class _TrackingEmpty extends StatelessWidget {
  const _TrackingEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 64, color: Colors.black26),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma ocorrência ativa',
            style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Abra uma nova ocorrência para acompanhar aqui.',
            style: TextStyle(fontSize: 13, color: Colors.black38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTEÚDO PRINCIPAL
// ─────────────────────────────────────────────────────────────────────────────

class _TrackingContent extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  const _TrackingContent({required this.ocorrencia});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusBanner(status: ocorrencia.status),
            const SizedBox(height: 20),
            _TrackingTimeline(status: ocorrencia.status),
            const SizedBox(height: 20),
            _OcorrenciaInfoCard(ocorrencia: ocorrencia),
            const SizedBox(height: 20),
            if (ocorrencia.unidade != null)
              _UnidadeCard(unidade: ocorrencia.unidade!),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BANNER DE STATUS
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final String status;
  const _StatusBanner({required this.status});

  String get _label {
    switch (status) {
      case 'em_atendimento':
        return 'Em Atendimento';
      case 'concluida':
        return 'Concluída';
      default:
        return 'Aguardando';
    }
  }

  Color get _color {
    switch (status) {
      case 'em_atendimento':
        return AppColors.colorButtonRed;
      case 'concluida':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFFF57C00);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, color: _color, size: 12),
          const SizedBox(width: 10),
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TIMELINE DE PROGRESSO
// ─────────────────────────────────────────────────────────────────────────────

class _TrackingTimeline extends StatelessWidget {
  final String status;
  const _TrackingTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'label': 'Ocorrência Aberta', 'done': true},
      {'label': 'Aguardando Atribuição', 'done': true},
      {
        'label': 'Unidade a Caminho',
        'done': status == 'em_atendimento' || status == 'concluida',
      },
      {'label': 'Atendimento Concluído', 'done': status == 'concluida'},
    ];

    return Card(
      color: Colors.white,
      elevation: 2,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progresso',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.colorButtonRed,
              ),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isDone = step['done'] as bool;
              final isLast = index == steps.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone
                              ? AppColors.colorButtonRed
                              : Colors.grey.shade200,
                          border: Border.all(
                            color: isDone
                                ? AppColors.colorButtonRed
                                : Colors.grey.shade400,
                          ),
                        ),
                        child: isDone
                            ? const Icon(Icons.check,
                            color: Colors.white, size: 14)
                            : null,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 32,
                          color: isDone
                              ? AppColors.colorButtonRed
                              : Colors.grey.shade300,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      step['label'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isDone
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color:
                        isDone ? Colors.black87 : Colors.black38,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD DE INFORMAÇÕES DA OCORRÊNCIA
// ─────────────────────────────────────────────────────────────────────────────

class _OcorrenciaInfoCard extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  const _OcorrenciaInfoCard({required this.ocorrencia});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppColors.colorButtonRed, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Detalhes da Ocorrência',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorButtonRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _InfoRow(label: 'ID', value: ocorrencia.id),
            _InfoRow(label: 'Título', value: ocorrencia.titulo),
            _InfoRow(label: 'Local', value: ocorrencia.local),
            _InfoRow(label: 'Nível', value: ocorrencia.nivel),
            _InfoRow(label: 'Aberta em', value: ocorrencia.data),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD DA UNIDADE EM DESLOCAMENTO
// ─────────────────────────────────────────────────────────────────────────────

class _UnidadeCard extends StatelessWidget {
  final String unidade;
  const _UnidadeCard({required this.unidade});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colorButtonRed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_shipping_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Unidade em Deslocamento',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                unidade,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}