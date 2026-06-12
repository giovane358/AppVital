// lib/features/user/history/user_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/models/ocorrencia_model.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/features/history/user_history_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────

class UserHistoryPage extends StatelessWidget {
  const UserHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserHistoryBloc()..add(StartUserHistory()),
      child: const _UserHistoryView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _UserHistoryView extends StatelessWidget {
  const _UserHistoryView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserHistoryBloc, UserHistoryState>(
      listener: (context, state) {
        if (state is UserHistoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao carregar histórico.')),
          );
        }
      },
      child: const _UserHistoryScaffold(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCAFFOLD
// ─────────────────────────────────────────────────────────────────────────────

class _UserHistoryScaffold extends StatelessWidget {
  const _UserHistoryScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        title: const Text(
          'Histórico',
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
      body: BlocBuilder<UserHistoryBloc, UserHistoryState>(
        builder: (context, state) {
          if (state is UserHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.colorButtonRed),
            );
          }
          if (state is UserHistoryEmpty) {
            return const _HistoryEmpty();
          }
          if (state is UserHistoryLoaded) {
            return _HistoryList(ocorrencias: state.ocorrencias);
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

class _HistoryEmpty extends StatelessWidget {
  const _HistoryEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.history_rounded, size: 64, color: Colors.black26),
          SizedBox(height: 16),
          Text(
            'Nenhuma ocorrência anterior',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LISTA DE OCORRÊNCIAS
// ─────────────────────────────────────────────────────────────────────────────

class _HistoryList extends StatelessWidget {
  final List<OcorrenciaModel> ocorrencias;
  const _HistoryList({required this.ocorrencias});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 20),
      itemCount: ocorrencias.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _HistoryCard(ocorrencia: ocorrencias[index]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD DE ITEM DO HISTÓRICO
// ─────────────────────────────────────────────────────────────────────────────

class _HistoryCard extends StatelessWidget {
  final OcorrenciaModel ocorrencia;
  const _HistoryCard({required this.ocorrencia});

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: _nivelColor, width: 5)),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _nivelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ocorrencia.nivel,
                  style: TextStyle(
                    fontSize: 11,
                    color: _nivelColor,
                    fontWeight: FontWeight.w700,
                  ),
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
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 13,
                color: Colors.black45,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  ocorrencia.local,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Colors.black45,
              ),
              const SizedBox(width: 4),
              Text(
                ocorrencia.data,
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
