import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/core/utils/img.dart';
import 'package:vital_application/features/auth/auth_widget.dart';
import 'auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => AuthBloc(), child: _LoginView());
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  void disponse() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
        if (state is AuthLoginFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário ou seha inválidos')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColos.colorBackground,
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Img.logoName),
                  SizedBox(height: 35),
                  Text('Acesse sua conta', style: TextStyle(fontSize: 32)),
                  SizedBox(height: 35),
                  toggleCustom(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _isLogin = true),
                          child: AnimatedContainer(
                            duration: const Duration(microseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _isLogin
                                  ? AppColos.colorButtonRed
                                  : AppColos.colorBackground,
                              borderRadius: BorderRadius.circular(30),
                              border: _isLogin
                                  ? Border.all(color: Colors.black, width: 2)
                                  : Border.all(color: Colors.white, width: 0),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                                color: _isLogin ? Colors.white : Colors.black45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _isLogin = false),
                          child: AnimatedContainer(
                            duration: const Duration(microseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _isLogin
                                  ? AppColos.colorBackground
                                  : AppColos.colorButtonRed,
                              borderRadius: BorderRadius.circular(30),
                              border: _isLogin
                                  ? Border.all(color: Colors.white, width: 0)
                                  : Border.all(color: Colors.black, width: 2),
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 20,
                                color: _isLogin ? Colors.black45 : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_isLogin) _ForumLogin() else _ForumRegister(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ForumLogin extends StatefulWidget {
  const _ForumLogin();

  @override
  State<_ForumLogin> createState() => __ForumLoginState();
}

class __ForumLoginState extends State<_ForumLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _iconPassword = Icons.visibility_outlined;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          textFieldCustom(
            obscureText: false,
            hint: 'E-mail',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10),
          textFieldPasswordCustom(
            icon: GestureDetector(
              onTap: () {
                if (_iconPassword == Icons.visibility_outlined) {
                  setState(() {
                    _iconPassword = Icons.visibility_off_outlined;
                    _obscureText = false;
                  });
                } else {
                  setState(() {
                    _iconPassword = Icons.visibility_outlined;
                    _obscureText = true;
                  });
                }
              },
              child: Icon(_iconPassword),
            ),

            obscureText: _obscureText,
            hint: 'Senha',
            controller: _passwordController,
          ),
          SizedBox(height: 10),
          buttonCustom(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(
                    AuthLoginStart(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    ),
                  );
                },
                child: Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColos.colorFontWhite,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Esqueci a senha!',
            style: TextStyle(fontSize: 12, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}

class _ForumRegister extends StatefulWidget {
  const _ForumRegister();

  @override
  State<_ForumRegister> createState() => __ForumRegisterState();
}

class __ForumRegisterState extends State<_ForumRegister> {
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController(
    text: UtilBrasilFields.obterTelefone('(00) 99999-8877', mascara: false),
  );
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var _iconPassword = Icons.visibility_outlined;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            textFieldCustom(
              obscureText: false,
              hint: 'Nome Completo',
              controller: _nomeController,
              keyboardType: TextInputType.name,
            ),
            textFieldFormatterCustom(
              obscureText: false,
              hint: 'CPF',
              controller: _cpfController,
              formatter: CpfInputFormatter(),
            ),
            textFieldFormatterCustom(
              obscureText: false,
              hint: 'Telefone',
              controller: _telefoneController,
              formatter: TelefoneInputFormatter(),
            ),
            textFieldCustom(
              obscureText: false,
              hint: 'E-mail',
              controller: _emailController,
              keyboardType: TextInputType.number,
            ),
            textFieldPasswordCustom(
              icon: GestureDetector(
                onTap: () {
                  if (_iconPassword == Icons.visibility_outlined) {
                    setState(() {
                      _iconPassword = Icons.visibility_off_outlined;
                      _obscureText = false;
                    });
                  } else {
                    setState(() {
                      _iconPassword = Icons.visibility_outlined;
                      _obscureText = true;
                    });
                  }
                },
                child: Icon(_iconPassword),
              ),

              obscureText: _obscureText,
              hint: 'Senha',
              controller: _passwordController,
            ),
            textFieldPasswordCustom(
              icon: GestureDetector(
                onTap: () {
                  if (_iconPassword == Icons.visibility_outlined) {
                    setState(() {
                      _iconPassword = Icons.visibility_off_outlined;
                      _obscureText = false;
                    });
                  } else {
                    setState(() {
                      _iconPassword = Icons.visibility_outlined;
                      _obscureText = true;
                    });
                  }
                },
                child: Icon(_iconPassword),
              ),

              obscureText: _obscureText,
              hint: 'Confirme a Senha',
              controller: _confirmPasswordController,
            ),

            buttonCustom(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (UtilBrasilFields.isCPFValido(
                          _cpfController.text.trim(),
                        ) ==
                        true) {
                      if (_passwordController.text.trim() ==
                          _confirmPasswordController.text.trim()) {
                        context.read<AuthBloc>().add(
                          AuthRegisterStart(
                            name: _nomeController.text.trim(),
                            cpf: _cpfController.text.trim(),
                            telefone: _telefoneController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Senhas não confere')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('CPF incorreto')),
                      );
                    }
                  },
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColos.colorFontWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
