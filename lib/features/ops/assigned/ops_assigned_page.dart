// lib/features/ops/assigned/ops_assigned_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/core/widgets/button_custom.dart';
import 'package:vital_application/features/ops/assigned/ops_assigned_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────

class OpsAssignedPage extends StatelessWidget {
  const OpsAssignedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OpsAssignedBloc()..add(StartOpsAssigned()),
      child: const _OpsAssignedView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _OpsAssignedView extends StatelessWidget {
  const _OpsAssignedView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpsAssignedBloc, OpsAssignedState>(
      listener: (context, state) {
        if (state is OpsAssignedNavigating) {
          Navigator.pushNamed(context, '/ops/navigation');
        }
        if (state is OpsAssignedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao carregar atribuição.')),
          );
        }
      },
      child: const _OpsAssignedScaffold(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCAFFOLD
// ─────────────────────────────────────────────────────────────────────────────

class _OpsAssignedScaffold extends StatelessWidget {
  const _OpsAssignedScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        title: const Text(
          'Minha Ocorrência',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.colorButtonRed,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<OpsAssignedBloc, OpsAssignedState>(
        builder: (context, state) {
          if (state is OpsAssignedLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.colorButtonRed),
            );
          }
          if (state is OpsAssignedLoaded) {
            return _AssignedContent(ocorrencia: state.ocorrencia);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTEÚDO
// ─────────────────────────────────────────────────────────────────────────────

class _AssignedContent extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  const _AssignedContent({required this.ocorrencia});

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
            // Status ativo
            _AtivoBanner(ocorrencia: ocorrencia),
            const SizedBox(height: 20),

            // Detalhes
            _AssignedInfoCard(ocorrencia: ocorrencia),
            const SizedBox(height: 20),

            // Descrição
            if (ocorrencia.descricao.isNotEmpty)
              _AssignedDescCard(descricao: ocorrencia.descricao),
            const SizedBox(height: 32),

            // Botão navegar
            ButtonCustom(
              onTap: () {
                context
                    .read<OpsAssignedBloc>()
                    .add(IniciarNavegacao());
              },
              child: const Text(
                'INICIAR NAVEGAÇÃO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Botão finalizar (outline)
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, '/ops/final-service'),
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 45, vertical: 5),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: AppColors.colorButtonRed, width: 1.5),
                  color: Colors.transparent,
                ),
                child: const Center(
                  child: Text(
                    'FINALIZAR ATENDIMENTO',
                    style: TextStyle(
                      color: AppColors.colorButtonRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AtivoBanner extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  const _AtivoBanner({required this.ocorrencia});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colorButtonRed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ocorrência Atribuída',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            ocorrencia.titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ocorrencia.id,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _AssignedInfoCard extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  const _AssignedInfoCard({required this.ocorrencia});

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
          children: [
            _InfoLine(
                icon: Icons.location_on_outlined,
                label: 'Local',
                value: ocorrencia.local),
            _InfoLine(
                icon: Icons.warning_amber_rounded,
                label: 'Nível',
                value: ocorrencia.nivel),
            _InfoLine(
                icon: Icons.access_time_rounded,
                label: 'Recebida',
                value: ocorrencia.data),
            if (ocorrencia.unidade != null)
              _InfoLine(
                  icon: Icons.local_shipping_rounded,
                  label: 'Unidade',
                  value: ocorrencia.unidade!),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoLine(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.colorButtonRed),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.black38)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssignedDescCard extends StatelessWidget {
  final String descricao;
  const _AssignedDescCard({required this.descricao});

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
            const Text(
              'Descrição do Incidente',
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.colorButtonRed,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              descricao,
              style: const TextStyle(
                  fontSize: 13, color: Colors.black87, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}