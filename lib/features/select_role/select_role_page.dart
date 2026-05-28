// lib/features/select_role/select_role_page.dart

import 'package:flutter/material.dart';
import 'package:vital_application/core/utils/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────

class SelectRolePage extends StatelessWidget {
  const SelectRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SelectRoleScaffold();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCAFFOLD
// ─────────────────────────────────────────────────────────────────────────────

class _SelectRoleScaffold extends StatelessWidget {
  const _SelectRoleScaffold();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width  = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Stack(
        children: [
          // Faixa vermelha superior (22% da altura — espelha home_page.dart)
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: height * 0.22,
              color: AppColors.colorButtonRed,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _SelectRoleHeader(height: height),
                    _SelectRoleBody(width: width),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER — logo + título na faixa vermelha
// ─────────────────────────────────────────────────────────────────────────────

class _SelectRoleHeader extends StatelessWidget {
  final double height;
  const _SelectRoleHeader({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.28,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone de escudo representando o sistema de emergência
          Icon(
            Icons.local_hospital_rounded,
            color: Colors.white,
            size: 56,
          ),
          SizedBox(height: 12),
          Text(
            'VITAL',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Sistema de Gestão de Emergências',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BODY — seleção de perfil
// ─────────────────────────────────────────────────────────────────────────────

class _SelectRoleBody extends StatelessWidget {
  final double width;
  const _SelectRoleBody({required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              'Como você vai acessar?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          _RoleCard(
            icon: Icons.person_rounded,
            title: 'Sou Cidadão',
            description: 'Reportar emergências e acompanhar ocorrências',
            onTap: () => Navigator.pushReplacementNamed(context, '/user'),
          ),
          const SizedBox(height: 12),
          _RoleCard(
            icon: Icons.shield_rounded,
            title: 'Sou Operador',
            description: 'Gerenciar e atender ocorrências ativas',
            onTap: () => Navigator.pushReplacementNamed(context, '/ops'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD DE SELEÇÃO DE PERFIL
// Espelha o CustomCardMenu mas com layout vertical para dar mais destaque
// ─────────────────────────────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: const Border(
            left: BorderSide(color: AppColors.colorButtonRed, width: 5),
          ),
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
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: AppColors.colorButtonRed.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.colorButtonRed, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.colorButtonRed,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.colorButtonRed,
            ),
          ],
        ),
      ),
    );
  }
}