// Caminho lib/features/auth/presentation/pages/signup_screen.dart

import 'package:flutter/material.dart';
import 'login_screen.dart';

import '../controller/auth_controller.dart'; // CONTROLLER
import 'package:provider/provider.dart'; // PROVIDER

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>(); // Para validar Form
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreeTerms = false;

  bool _passwordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // MÉTODO PARA LIDAR COM ENVIO DE FORMULÁRIO
  void _submitSignUpForm(BuildContext context) async {
    // VALIDA TODOS OS CAMPOS
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // VALIDA O CHECKBOX
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa concordar com os Termos e Condições.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ACESSA O AUTHCONTROLLER VIA PROVIDER
    // 'READ' POIS CRIAMOS UM MÉTODO QUE DISPARA UMA AÇÃO
    final authController = context.read<AuthController>();

    authController.clearErrorMessage();

    try {
      await authController.signUp(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim(), 
        name: _usernameController.text.trim(),
      );
    } catch (e) {
      debugPrint('Erro capturado na tela de cadastro: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final bool isLoading = authController.isLoading;
    final String? errorMessage = authController.errorMessage;

      return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLandScape = constraints.maxWidth > 600;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Pequena cenoura
                      SizedBox(
                        height: 65,
                        width: 65,
                        child: Image.asset(
                          'assets/carrot-preta-transparente.png',
                        ),
                      ),
                      SizedBox(height: 5),              

                      // Título
                      Text(
                        'Cadastre-se',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),

                      // Subtítulo
                      Text(
                        'Identifique-se para continuar',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),

                      isLandScape
                      ? Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Usuário',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty || value.trim().length < 3) {
                                    return 'Insira um usuário válido (mín. 3 caracteres)';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10),

                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  suffixIcon: _emailController.text.contains('@') && _emailController.text.isNotEmpty
                                    ? Icon(Icons.check_circle, color: Colors.green)
                                    : null
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // Apenas atualizando o ícone de validação
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty || !value.contains('@')) {
                                    return 'Insira um e-mail válido';
                                  }
                                  return null;
                                },  
                              ),
                            ), 
                          ],
                        )
                      : Column(
                        children: [
                          // Campo de nome do usário
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Usuário',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || value.trim().length < 3) {
                                return 'Insira um usuário válido (mín. 3 caracteres)';
                              }
                              return null;
                            } 
                          ),
                          SizedBox(height: 15),

                          // Campo de email do usuário
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              suffixIcon: _emailController.text.contains('@') && _emailController.text.isNotEmpty
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : null
                            ),                            
                            onChanged: (value) {
                              setState(() {
                                // Apenas atualizando o ícone de validação
                              });
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || !value.contains('@')) {
                                return 'Insira um e-mail válido';
                              }
                              return null;
                            }, 
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      
                      // Campo de senha do usuário
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'A senha precisa ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),

                      // Checkbox para aceitar termos
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeTerms,
                            onChanged: (newValue) {
                              setState(() {
                                _agreeTerms = newValue!;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              'Concordar com os Termos e Condições',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                      // MENSAGEM DE ERRO (VISÍVEL SE HOUVER ERRO NO AUTHCONTROLLER)
                      if (errorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      
                      // Botão de cadastro
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                            ? null
                            : () => _submitSignUpForm(context),
                          child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Cadastrar-se'),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Link para login
                      GestureDetector(
                        onTap: () {
                          // Navegação para tela de login
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen())
                          );
                        },
                        child: Text(
                          'Já possui uma conta? Clique aqui',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ), 
          );
        },
      ), 
    );
  }
}