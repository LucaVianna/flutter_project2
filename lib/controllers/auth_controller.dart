import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier{
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  // GETTERS PARA ACESSAR O ESTADO A PARTIR DA UI
  bool get isLoading => _isLoading;
  String? get erroMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  // CONSTRUTOR DO CONTROLADOR
  AuthController() {
    // ESCUTA O STREAM DE MUDANÇAS DE ESTADO DE AUTENTICAÇÃO
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        // SE HÁ UM USUÁRIO LOGADO, TENTA BUSCAR SEU PERFIIL
        _currentUser = await _authService.getUserProfile(firebaseUser.uid);
      } else {
        _currentUser = null;
      }
      notifyListeners(); // NOTIFICA OS WIDGETS QUE ESTÃO OUVINDO
    });
  }

  // MÉTODO PARA LIDAR COM O CADASTRO DE USUÁRIO (SIGNUP-SCREEN)
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // CHAMA O MÉTODO DE CADASTRO DO AUTHSERVICE
      await _authService.signUpWithEmailAndPassword(
        email: email, 
        password: password, 
        name: name,
      );
      // SE SIGNUP BEM-SUCEDIDO -> LISTENER AUTHSTATECHANGES NO CONSTRUTOR ATUALIZA O _CURRENTUSER
    } on FirebaseAuthException catch (e) {
      String message = 'Ocorreu um erro de autenticação.';
      if (e.code == 'email-already-in-use') {
        message = 'Este e-mail já está em uso. Tente fazer login ou use outro e-mail.';
      } else if (e.code == 'weak-password') {
        message = 'A senha fornecida é muito fraca.';
      }
      _errorMessage = message;
    } catch (e) {
      _errorMessage = 'Ocorreu um erro inesperado: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // MÉTODO PARA LIDAR COM O LOGIN DE USUÁRIO (LOGIN-SCREEN)
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
    } on FirebaseAuthException catch(e) {
      String message = 'Ocorreu um erro de autenticação';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Credenciais inválidas. Verifique seu e-mail e senha';
      } else if (e.code == 'invalid-email') {
        message = 'O formato do e-mail é inválido';
      }
      _errorMessage = message;
    } catch (e) {
      _errorMessage = 'Ocorreu um erro inesperado: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // MÉTODO PARA LIDAR COM O LOGOUT DO USUÁRIO (PROFILE-SCREEN)
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // MÉTODO AUXILIAR PARA LIMPAR A MENSAGEM DE ERRO
  void clearErrorMessage() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}