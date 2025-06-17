// Caminho lib/features/auth/presentation/controller/auth_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/models/user_model.dart';

class AuthController with ChangeNotifier{
  final AuthService _authService = AuthService();
  StreamSubscription? _authStateSubscription; // Guarda nossa 'escuta'

  bool _isLoading = false; // Para ações dos botões (Login/SignUp)
  bool _isInitializing = true; // Apenas para o loader inicial do app
  String? _errorMessage;
  UserModel? _currentUser;

  // GETTERS PARA ACESSAR O ESTADO A PARTIR DA UI
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  // CONSTRUTOR DO CONTROLADOR
  AuthController() {
    // Inicia a escuta contínua do estado de autenticação
    _authStateSubscription = _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  // Listener agora tem uma funcionalidade mais simples
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
    } else {
      if (_currentUser?.uid != firebaseUser.uid) {
        _currentUser = await _authService.getUserProfile(firebaseUser.uid);
      }
    }

    // Desliga o loading INICIAL apenas uma vez
    if (_isInitializing) {
      _isInitializing = false;
    }

    notifyListeners();
  }    

  // Sobrescreve o método dispose para cancelar a escuta e evitar memory leaks
  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
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
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
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