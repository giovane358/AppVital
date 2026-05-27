// lib/core/models/ocorrencia_model.dart

class OcorrenciaModel {
  final String id;
  final String titulo;
  final String local;
  final String descricao;
  final String nivel; // 'Baixa' | 'Média' | 'Alta'
  final String status; // 'aguardando' | 'em_atendimento' | 'concluida'
  final String data;
  final String? unidade;

  OcorrenciaModel({
    required this.id,
    required this.titulo,
    required this.local,
    required this.descricao,
    required this.nivel,
    required this.status,
    required this.data,
    this.unidade,
  });

  factory OcorrenciaModel.fromJson(Map<String, dynamic> json) {
    return OcorrenciaModel(
      id: json['id'],
      titulo: json['titulo'],
      local: json['local'],
      descricao: json['descricao'],
      nivel: json['nivel'],
      status: json['status'],
      data: json['data'],
      unidade: json['unidade'],
    );
  }
}