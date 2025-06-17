// Caminho lib/features/auth/presentation/controller/auth_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../pages/welcome_screen.dart';

// Gerencia todo o estado e lógica de autenticação do app
// Funciona como o cérebro para login, cadastro, logout e para usuário atualmente logado
class AuthController with ChangeNotifier{
  final AuthService _authService = AuthService();
  StreamSubscription? _authStateSubscription; // Guarda nossa 'escuta'

  // ESTADOS INTERNOS
  bool _isLoading = false; // Para ações dos botões (Login/SignUp)
  bool _isInitializing = true; // APENAS para inicialização do app
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

  // Listener: responsável pela inicialização e sempre que o estado muda (login, logout, etc)
  Future<void> _onAuthStateChanged(User? firebaseUser) async {    
    if (firebaseUser == null) {
      _currentUser = null;
    } else {
      // Se o usuário logado no Firebase for o mesmo que já temos, não faz nada
      if (firebaseUser.uid != _currentUser?.uid) {
        _currentUser = await _authService.getUserProfile(firebaseUser.uid);
      }
    }

    // Se esta foi a primeira verificação desde que o app abriu, o processo de inicialização terminou
    if (_isInitializing) {
      _isInitializing = false;
    }

    notifyListeners(); // Notifica todos os widgets ouvintes ('watch' ou 'Consumer')
  }    

  // Sobrescreve o método dispose para cancelar a escuta e evitar memory leaks
  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  // --- MÉTODOS DE AÇÃO COM LÓGICA REVISADA ---

  /// --- MÉTODO signUp COM CONTROLE TOTAL DO FLUXO ---
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. O serviço de autenticação agora retorna o UserModel
      final user = await _authService.signUpWithEmailAndPassword(
        email: email, 
        password: password, 
        name: name,
      );
      _currentUser = user;
      // 2. SUCESSO: comanda a navegação para a HomeScreen!
      if (user != null) {
        NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
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

  // --- MÉTODO signIn COM CONTROLE TOTAL DO FLUXO ---
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. O serviço de autenticação agora retorna o UserModel
      final user = await _authService.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
      _currentUser = user;

      // 2. SUCESSO: comanda a navegação para a HomeScreen!
      if (user != null) {
        NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
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

  // --- MÉTODO signOut COM CONTROLE TOTAL DO FLUXO ---
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      // Após o logout, comanda a navegação de volta para a Welcome Screen
      NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
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