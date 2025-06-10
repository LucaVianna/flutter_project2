import 'package:flutter/material.dart';
import './signup_screen.dart';
import './home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Para validar Form
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailValid = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
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

                      isLandScape
                      ? Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                  suffixIcon: _isEmailValid
                                    ? Icon(Icons.check_circle, color: Colors.green)
                                    : null
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _isEmailValid = value.contains('@');
                                  });
                                },
                                validator: (value) => value!.contains('@') ? null : 'Insira um email válido', 
                              ),
                            ), 
                          ],
                        )
                      : Column(
                        children: [
                          
                          // Campo de email do usuário
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              suffixIcon: _isEmailValid
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : null
                            ),                            
                            onChanged: (value) {
                              setState(() {
                                _isEmailValid = value.contains('@');
                              });
                            },
                            validator: (value) => value!.contains('@') ? null : 'Insira um email válido',
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      
                      // Campo de senha do usuário
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
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
                        validator: (value) => value!.length >= 6 ? null : 'Senha precisa de no mínimo 6 caracteres',
                      ),
                      SizedBox(height: 30),

                      // Botão de login
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen())
                              );
                              // final userData = {
                              //  'username': _usernameController.text,
                              //  'email': _emailController.text,
                              //  'password': _passwordController.text,
                              // };

                              // Navigator.push(
                              // context,
                              // MaterialPageRoute(builder: (context) => NextScreen(userData));
                              // );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            // Cor definida no ThemeData
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              // Cor definida no ThemeData
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Link para login
                      GestureDetector(
                        onTap: () {
                          // Navegação para tela de login
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen())
                          );
                        },
                        child: Text(
                          'Não possui uma conta? Clique aqui',
                          style: TextStyle(
                            color: Colors.green,
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