import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_application/core/utils/img.dart';
import 'package:vital_application/core/utils/widget.dart';
import 'package:vital_application/features/recp/recover_bloc.dart';

class RecoverPage extends StatelessWidget {
  const RecoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => RecoverBloc(), child: _RecoverView());
  }
}

class _RecoverView extends StatefulWidget {
  const _RecoverView();

  @override
  State<_RecoverView> createState() => _RecoverViewState();
}

class _RecoverViewState extends State<_RecoverView> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<RecoverBloc, RecoverSate>(
      listener: (context, state) {
        if (state is RecoverSuccess) {
          Navigator.of(context).pushReplacementNamed('/verifCode');
        }
        if (state is RecoverFalied) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Digite o seu e-mail!')));
        }
      },
      child: Scaffold(
        body: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //Centralizar no meio
            children: [
              Image.asset(Img.logoName),
              SizedBox(height: 25),
              Text(
                'Recuperar Senha',
                style: TextStyle(color: Colors.black, fontSize: 32),
              ),
              SizedBox(height: 25),
              TextFieldCustom(
                hint: 'Digite o seu e-mail',
                controller: _emailController,
              ),
              SizedBox(height: 15),
              buttonCustom(
                onTap: () {
                  context.read<RecoverBloc>().add(
                    RecoverStart(email: _emailController.text.trim()),
                  );
                },
                child: Center(
                  child: Text(
                    'Enviar código',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text(
                  'Voltar para tela de login',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
