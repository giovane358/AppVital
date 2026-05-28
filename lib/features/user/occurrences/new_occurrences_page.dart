import 'package:flutter/material.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/core/widgets/text_field_custom.dart';
import 'package:vital_application/core/widgets/button_custom.dart';

class NewOccurrencesPage extends StatefulWidget {
  const NewOccurrencesPage({super.key});

  @override
  State<NewOccurrencesPage> createState() => _NewOccurrencesPageState();
}

class _NewOccurrencesPageState extends State<NewOccurrencesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _emergencyLevel = 'Média';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _enviarOcorrencia() {
    final String titulo = _titleController.text;
    final String local = _locationController.text;

    if (titulo.isEmpty || local.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha o título e a localização!')),
      );
      return;
    }

    print('Disparando Ocorrência: $titulo em $local [Nível: $_emergencyLevel]');
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: AppColors.colorBackground,

        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),

          child: AppBar(

            elevation: 0,
            backgroundColor: AppColors.colorButtonRed,

          title: const Text(
            'Nova Ocorrência',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),

          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),

          ),
        ),


      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45),
                child: Text(
                  'Dados do Incidente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorButtonRed,
                  ),
                ),
              ),
              const SizedBox(height: 16),


              TextFieldCustom(
                hint: 'Título da Ocorrência (Ex: Acidente, Incêndio)',
                controller: _titleController,
                suffixIcon: const Icon(Icons.edit, color: AppColors.colorButtonRed, size: 20),
              ),
              const SizedBox(height: 8),

              TextFieldCustom(
                hint: 'Localização Exata ou Ponto de Referência',
                controller: _locationController,
                suffixIcon: const Icon(Icons.location_on, color: AppColors.colorButtonRed, size: 20),
              ),
              const SizedBox(height: 8),

              TextFieldCustom(
                hint: 'Descrição Breve dos Fatos (Opcional)',
                controller: _descriptionController,
                suffixIcon: const Icon(Icons.description, color: AppColors.colorButtonRed, size: 20),
              ),
              const SizedBox(height: 24),

              // 3. SELETOR DE GRAVIDADE (Ajustado para alinhar com os 45px do TextField)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nível de Gravidade Aparente:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['Baixa', 'Média', 'Alta'].map((level) {
                        final bool isSelected = _emergencyLevel == level;

                        // Cálculo matemático para dividir os 3 botões dentro do espaço restante (Largura total - 90px de margem)
                        final double availableWidth = width - 90;
                        final double buttonWidth = (availableWidth - 24) / 3;

                        return GestureDetector(
                          onTap: () => setState(() => _emergencyLevel = level),
                          child: Container(
                            width: buttonWidth,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.colorButtonRed : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.colorButtonRed, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                level,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.colorButtonRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 4. SEU BOTÃO GLOBAL REUTILIZADO
              ButtonCustom(
                onTap: _enviarOcorrencia,
                child: const Text(
                  'DISPARAR ALERTA',
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
    );
  }
}