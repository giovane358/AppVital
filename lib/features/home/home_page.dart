import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/features/home/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeBloc(), child: _HomeView());
  }
}

class _HomeView extends StatefulWidget {
  @override
  State<_HomeView> createState() => __HomeViewState();
}

class __HomeViewState extends State<_HomeView> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is CheckLoginSucess) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
        if (state is CheckLoginRetried) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: BackgroundColor(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.redAccent[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, Giovane',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    'Como podemos ajudar voce hoje?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardView(
                    icons: Icons.analytics_rounded,
                    title: 'Ocorrencia Ativa',
                    description: 'INC-2024-001 . Unidade A-12 a Caminho',
                    textIcon: 'Ver',
                    border: Border(
                      left: BorderSide(color: Colors.red, width: 5),
                    ),
                  ),
                  CardView(
                    icons: Icons.add,
                    title: 'Nova Ocorrencia',
                    description: 'Reportar uma emergencia ou incidente',
                    textIcon: 'Ver',
                    border: Border(
                      left: BorderSide(color: Colors.red, width: 5),
                    ),
                  ),
                  CardView(
                    icons: Icons.analytics_rounded,
                    title: 'Acompanhar',
                    description: 'ver o status da sua ocorrencia ativa',
                    textIcon: 'Ver',
                    border: Border(
                      left: BorderSide(color: Colors.red, width: 5),
                    ),
                  ),
                  CardView(
                    icons: Icons.analytics_rounded,
                    title: 'Histoórico',
                    description: 'Suas ocorrencia aanteriores',
                    textIcon: 'Ver',
                    border: Border(
                      left: BorderSide(color: Colors.red, width: 5),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 1,
                vertical: height * 0.01,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.01,
                vertical: height * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dicas de Segurança',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.check_box, color: AppColors.colorButtonRed),
                      SizedBox(width: 20),
                      Text('Em caso de risco de vida, ligue 192 (SAMU)'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.check_box, color: AppColors.colorButtonRed),
                      SizedBox(width: 20),
                      Text('Informe localização precisa ao abrir ocorrencia'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.check_box, color: AppColors.colorButtonRed),
                      SizedBox(width: 20),
                      Text(
                        'Mantenha o celular com voce até a chegada da equipe',
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Text("Sait"),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();

                      await prefs.remove('token');

                      Navigator.pushReplacementNamed(context, '/login');
                    },
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

class BackgroundColor extends StatelessWidget {
  final Widget child;
  const BackgroundColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: AppColors.colorBackground),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: height * 0.2,
              width: double.infinity,
              color: AppColors.colorButtonRed,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final String title;
  final String description;
  final Icon? icon;
  final String textIcon;
  final Border? border;
  final IconData? icons;
  const CardView({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    required this.textIcon,
    this.border,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: height * 0.03),
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.07,
        vertical: height * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: border,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icons, color: AppColors.colorButtonRed),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: AppColors.colorButtonRed, fontSize: 16),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.black38, fontSize: 14),
              ),
            ],
          ),

          Text(
            textIcon,
            style: TextStyle(color: AppColors.colorButtonRed, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
