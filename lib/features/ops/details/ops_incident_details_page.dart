// lib/features/ops/details/ops_incident_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/core/widgets/button_custom.dart';
import 'package:vital_application/features/ops/details/ops_incident_detais_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT — recebe OcorrenciaModel via arguments do Navigator
// ─────────────────────────────────────────────────────────────────────────────

class OpsIncidentDetailsPage extends StatelessWidget {
  const OpsIncidentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ocorrencia =
    ModalRoute.of(context)!.settings.arguments as OcorrenciaModel;

    return BlocProvider(
      create: (_) => OpsIncidentDetailsBloc()
        ..add(StartOpsIncidentDetails(ocorrencia: ocorrencia)),
      child: const _OpsIncidentDetailsView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _OpsIncidentDetailsView extends StatelessWidget {
  const _OpsIncidentDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpsIncidentDetailsBloc, OpsIncidentDetailsState>(
      listener: (context, state) {
        if (state is OpsIncidentDetailsAtribuida) {
          Navigator.of(context).pushReplacementNamed('/ops/assigned');
        }
        if (state is OpsIncidentDetailsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao atribuir ocorrência.')),
          );
        }
      },
      child: const _OpsIncidentDetailsScaffold(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCAFFOLD
// ─────────────────────────────────────────────────────────────────────────────

class _OpsIncidentDetailsScaffold extends StatelessWidget {
  const _OpsIncidentDetailsScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        title: const Text(
          'Detalhes da Ocorrência',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.colorButtonRed,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<OpsIncidentDetailsBloc, OpsIncidentDetailsState>(
        builder: (context, state) {
          if (state is OpsIncidentDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.colorButtonRed),
            );
          }
          if (state is OpsIncidentDetailsLoaded) {
            return _DetailsContent(
              ocorrencia: state.ocorrencia,
              isLoading: false,
            );
          }
          if (state is OpsIncidentDetailsAtribuindo) {
            return _DetailsContent(
              ocorrencia: state.ocorrencia,
              isLoading: true,
            );
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

class _DetailsContent extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  final bool isLoading;
  const _DetailsContent({
    required this.ocorrencia,
    required this.isLoading,
  });

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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de nível
          Container(
            width: double.infinity,
            color: _nivelColor,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Nível de Gravidade: ${ocorrencia.nivel}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID + Título
                Text(
                  ocorrencia.id,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  ocorrencia.titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Card de informações
                _InfoCard(ocorrencia: ocorrencia),
                const SizedBox(height: 16),

                // Descrição
                if (ocorrencia.descricao.isNotEmpty)
                  _DescricaoCard(descricao: ocorrencia.descricao),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Botão de atribuir
          isLoading
              ? const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(
                  color: AppColors.colorButtonRed),
            ),
          )
              : ButtonCustom(
            onTap: () {
              context.read<OpsIncidentDetailsBloc>().add(
                AtribuirOcorrencia(
                    ocorrenciaId: ocorrencia.id),
              );
            },
            child: const Text(
              'ATRIBUIR A MIM',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  const _InfoCard({required this.ocorrencia});

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
            _Row(
                icon: Icons.location_on_outlined,
                label: 'Local',
                value: ocorrencia.local),
            _Row(
                icon: Icons.access_time_rounded,
                label: 'Aberta em',
                value: ocorrencia.data),
            _Row(
                icon: Icons.flag_outlined,
                label: 'Status',
                value: ocorrencia.status == 'aguardando'
                    ? 'Aguardando Atribuição'
                    : 'Em Atendimento'),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Row(
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

class _DescricaoCard extends StatelessWidget {
  final String descricao;
  const _DescricaoCard({required this.descricao});

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
              'Descrição',
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