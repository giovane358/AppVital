// lib/features/ops/navigation/ops_navigation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/core/widgets/button_custom.dart';
import 'package:vital_application/features/navigation/ops_navigation_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────

class OpsNavigationPage extends StatelessWidget {
  const OpsNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OpsNavigationBloc()..add(StartOpsNavigation()),
      child: const _OpsNavigationView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _OpsNavigationView extends StatelessWidget {
  const _OpsNavigationView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpsNavigationBloc, OpsNavigationState>(
      listener: (context, state) {
        if (state is OpsNavigationChegou) {
          Navigator.pushReplacementNamed(context, '/ops/final-service');
        }
        if (state is OpsNavigationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao carregar navegação.')),
          );
        }
      },
      child: const _OpsNavigationScaffold(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCAFFOLD
// ─────────────────────────────────────────────────────────────────────────────

class _OpsNavigationScaffold extends StatelessWidget {
  const _OpsNavigationScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        title: const Text(
          'Navegação',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.colorButtonRed,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<OpsNavigationBloc, OpsNavigationState>(
        builder: (context, state) {
          if (state is OpsNavigationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.colorButtonRed),
            );
          }
          if (state is OpsNavigationLoaded) {
            return _NavigationContent(state: state);
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

class _NavigationContent extends StatelessWidget {
  final OpsNavigationLoaded state;
  const _NavigationContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Área do mapa (placeholder — substituir por flutter_map ou google_maps)
        _MapPlaceholder(height: height * 0.40, local: state.ocorrencia.local),

        // Painel inferior de navegação
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Métricas de rota
                  _RouteMetrics(
                    distancia: state.distancia,
                    tempo: state.tempoEstimado,
                  ),
                  const SizedBox(height: 16),

                  // Destino
                  _DestinationCard(ocorrencia: state.ocorrencia),
                  const SizedBox(height: 28),

                  // Botão confirmar chegada
                  ButtonCustom(
                    onTap: () {
                      context.read<OpsNavigationBloc>().add(ChegouAoLocal());
                    },
                    child: const Text(
                      'CONFIRMAR CHEGADA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER DO MAPA
// Substituir por flutter_map / google_maps_flutter quando integrado
// ─────────────────────────────────────────────────────────────────────────────

class _MapPlaceholder extends StatelessWidget {
  final double height;
  final String local;
  const _MapPlaceholder({required this.height, required this.local});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFE8EAF0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Grade de ruas simulada
          CustomPaint(
            size: Size(double.infinity, height),
            painter: _MapGridPainter(),
          ),
          // Ícone de destino
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.colorButtonRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  local,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// MÉTRICAS DE ROTA
// ─────────────────────────────────────────────────────────────────────────────

class _RouteMetrics extends StatelessWidget {
  final String distancia;
  final String tempo;
  const _RouteMetrics({required this.distancia, required this.tempo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            icon: Icons.straighten_rounded,
            label: 'Distância',
            value: distancia,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricTile(
            icon: Icons.timer_outlined,
            label: 'Tempo Est.',
            value: tempo,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.colorButtonRed, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.black38),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD DE DESTINO
// ─────────────────────────────────────────────────────────────────────────────

class _DestinationCard extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  const _DestinationCard({required this.ocorrencia});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.colorButtonRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.flag_rounded,
                color: AppColors.colorButtonRed,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Destino',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ocorrencia.local,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ocorrencia.id} · ${ocorrencia.titulo}',
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
