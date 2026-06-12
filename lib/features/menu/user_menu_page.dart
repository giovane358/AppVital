// lib/features/user/menu/user_menu_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/core/widgets/card_menu.dart';
import 'package:vital_application/features/menu/user_menu_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────

class UserMenuPage extends StatelessWidget {
  const UserMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UserMenuBloc()..add(const StartUserMenu(userName: 'Giovane')),
      child: const _UserMenuView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW — ouve o BLoC e direciona para o Scaffold
// ─────────────────────────────────────────────────────────────────────────────

class _UserMenuView extends StatelessWidget {
  const _UserMenuView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserMenuBloc, UserMenuState>(
      listener: (context, state) {
        if (state is UserMenuError) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: const _UserMenuScaffold(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCAFFOLD
// ─────────────────────────────────────────────────────────────────────────────

class _UserMenuScaffold extends StatelessWidget {
  const _UserMenuScaffold();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Stack(
        children: [
          // Faixa vermelha no topo (padrão do projeto — vide home_page.dart)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height * 0.22,
              color: AppColors.colorButtonRed,
            ),
          ),

          SafeArea(
            child: BlocBuilder<UserMenuBloc, UserMenuState>(
              builder: (context, state) {
                if (state is UserMenuLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.colorButtonRed,
                    ),
                  );
                }

                if (state is UserMenuReady) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _UserMenuHeader(userName: state.userName),
                        _UserMenuGreeting(userName: state.userName),
                        const SizedBox(height: 8),
                        _UserMenuCards(
                          hasActiveOccurrence: state.hasActiveOccurrence,
                        ),
                        const SizedBox(height: 8),
                        const _UserMenuSafetyTips(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }

                // UserMenuError é tratado pelo BlocListener acima
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
// HEADER — ícone de notificação
// ─────────────────────────────────────────────────────────────────────────────

class _UserMenuHeader extends StatelessWidget {
  final String userName;
  const _UserMenuHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SAUDAÇÃO
// ─────────────────────────────────────────────────────────────────────────────

class _UserMenuGreeting extends StatelessWidget {
  final String userName;
  const _UserMenuGreeting({required this.userName});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: width * 0.05,
        right: width * 0.05,
        top: 52,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, $userName 👋',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Como podemos ajudar você hoje?',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARDS DE MENU
// Reutiliza CustomCardMenu — vide lib/core/widgets/card_menu.dart
// ─────────────────────────────────────────────────────────────────────────────

class _UserMenuCards extends StatelessWidget {
  final bool hasActiveOccurrence;
  const _UserMenuCards({required this.hasActiveOccurrence});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card de ocorrência ativa só é exibido quando existe uma
        if (hasActiveOccurrence)
          CustomCardMenu(
            icon: Icons.local_fire_department_rounded,
            title: 'Ocorrência Ativa',
            description: 'INC-2024-001 · Unidade A-12 a caminho',
            onTap: () => Navigator.pushNamed(context, '/tracking'),
          ),
        CustomCardMenu(
          icon: Icons.add_circle_outline_rounded,
          title: 'Nova Ocorrência',
          description: 'Reportar uma emergência ou incidente',
          onTap: () => Navigator.pushNamed(context, '/open-incident'),
        ),
        CustomCardMenu(
          icon: Icons.my_location_rounded,
          title: 'Acompanhar',
          description: 'Ver o status da sua ocorrência ativa',
          onTap: () => Navigator.pushNamed(context, '/tracking'),
        ),
        CustomCardMenu(
          icon: Icons.history_rounded,
          title: 'Histórico',
          description: 'Suas ocorrências anteriores',
          onTap: () => Navigator.pushNamed(context, '/history'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DICAS DE SEGURANÇA
// ─────────────────────────────────────────────────────────────────────────────

class _UserMenuSafetyTips extends StatelessWidget {
  const _UserMenuSafetyTips();

  static const List<String> _tips = [
    'Em caso de risco de vida, ligue 192 (SAMU)',
    'Informe a localização precisa ao abrir ocorrência',
    'Mantenha o celular com você até a chegada da equipe',
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dicas de Segurança',
                style: TextStyle(
                  color: AppColors.colorButtonRed,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ..._tips.map(
                (tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_box_rounded,
                        color: AppColors.colorButtonRed,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
