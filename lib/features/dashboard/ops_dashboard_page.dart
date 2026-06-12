// lib/features/ops/dashboard/ops_dashboard_page.dart
// Rota: /ops  (index do OpsLayout)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/features/ops/dashboard/ops_dashboard_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────

class OpsDashboardPage extends StatelessWidget {
  const OpsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OpsDashboardBloc()..add(StartOpsDashboard()),
      child: const _OpsDashboardView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _OpsDashboardView extends StatelessWidget {
  const _OpsDashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpsDashboardBloc, OpsDashboardState>(
      listener: (context, state) {
        if (state is OpsDashboardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao carregar dashboard.')),
          );
        }
      },
      child: const _OpsDashboardScaffold(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCAFFOLD
// ─────────────────────────────────────────────────────────────────────────────

class _OpsDashboardScaffold extends StatelessWidget {
  const _OpsDashboardScaffold();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: height * 0.22,
              color: AppColors.colorButtonRed,
            ),
          ),
          SafeArea(
            child: BlocBuilder<OpsDashboardBloc, OpsDashboardState>(
              builder: (context, state) {
                if (state is OpsDashboardLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Colors.white),
                  );
                }
                if (state is OpsDashboardLoaded) {
                  return _DashboardContent(state: state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTEÚDO
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardContent extends StatelessWidget {
  final OpsDashboardLoaded state;
  const _DashboardContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DashboardHeader(),
          _DashboardSummary(
            totalAtivas: state.totalAtivas,
            totalConcluidas: state.totalConcluidas,
            novas: state.novas.length,
          ),
          const SizedBox(height: 20),
          _NovasOcorrencias(novas: state.novas),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: width * 0.05,
        right: width * 0.05,
        top: 20,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Central de Operações',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Novas ocorrências aguardando atribuição',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RESUMO — 3 métricas
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardSummary extends StatelessWidget {
  final int novas;
  final int totalAtivas;
  final int totalConcluidas;
  const _DashboardSummary({
    required this.novas,
    required this.totalAtivas,
    required this.totalConcluidas,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        children: [
          _MetricCard(label: 'Novas', value: '$novas', highlight: true),
          const SizedBox(width: 10),
          _MetricCard(label: 'Ativas', value: '$totalAtivas'),
          const SizedBox(width: 10),
          _MetricCard(label: 'Concluídas', value: '$totalConcluidas'),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _MetricCard({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: highlight ? AppColors.colorButtonRed : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: highlight ? Colors.white : AppColors.colorButtonRed,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: highlight ? Colors.white70 : Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LISTA DE NOVAS OCORRÊNCIAS
// ─────────────────────────────────────────────────────────────────────────────

class _NovasOcorrencias extends StatelessWidget {
  final List<OcorrenciaModel> novas;
  const _NovasOcorrencias({required this.novas});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: const Text(
            'Aguardando Atribuição',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (novas.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: const Text(
              'Nenhuma nova ocorrência no momento.',
              style: TextStyle(fontSize: 13, color: Colors.black45),
            ),
          )
        else
          ...novas.map((o) => _NovaOcorrenciaCard(ocorrencia: o)),
      ],
    );
  }
}

class _NovaOcorrenciaCard extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  const _NovaOcorrenciaCard({required this.ocorrencia});

  Color get _nivelColor {
    switch (ocorrencia.nivel) {
      case 'Alta':
        return AppColors.colorButtonRed;
      case 'Média':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/ops/incident',
        arguments: ocorrencia,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: 6),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: _nivelColor, width: 5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ocorrencia.id,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _nivelColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ocorrencia.nivel,
                    style: TextStyle(
                        fontSize: 11,
                        color: _nivelColor,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ocorrencia.titulo,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 13, color: Colors.black45),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ocorrencia.local,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black45),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 13, color: Colors.black45),
                const SizedBox(width: 4),
                Text(
                  ocorrencia.data,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}