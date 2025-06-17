// Caminho lib/features/auth/presentation/pages/login_screen.dart

import 'package:flutter/material.dart';
import 'signup_screen.dart';

// PROVIDER
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // Limpa a mensagem de erro ao construir a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearErrorMessage();
    });
  }

  final _formKey = GlobalKey<FormState>(); // Para validar Form
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // MÉTODO PARA LIDAR COM ENVIO DO FORM LOGIN
  void _submitLoginForm(BuildContext context) async {
    // VALIDA TODOS OS CAMPOS
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authController = context.read<AuthProvider>();

    authController.clearErrorMessage();

    try {
      // CHAMA O SIGNIN DO AUTHCONTROLLER
      await authController.signIn(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim(),
      );
    } catch (e) {
      debugPrint('Erro capturado na tela de login: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthProvider>();
    final bool isLoading = authController.isLoading;
    final String? errorMessage = authController.errorMessage;

    return Scaffold(
      body: Padding(
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
                    'Log in',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),

                  // Subtítulo
                  Text(
                    'Coloque seus dados para continuar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  Column(
                    children: [
                      
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
                            // Apenas para atualizar o ícone de validação visual
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
                  SizedBox(height: 30),

                  if (errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 15
                      ),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  // Botão de login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                        ? null
                        : () => _submitLoginForm(context),
                      child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Entrar')
                    ),
                  ),
                  SizedBox(height: 15),

                  // Link para login
                  GestureDetector(
                    onTap: () {
                      // Navegação para tela de login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen())
                      );
                    },
                    child: Text(
                      'Não possui uma conta? Clique aqui',
                      style: TextStyle(
                        color:Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ), 
      ),
    ); 
  }
}