// Caminho lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // OBSERVA MUDANÇAS NO ESTADO DE AUTENTICAÇÃO (LOGADO/DESLOGADO)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // MÉTODO PARA CADASTRO DE USUÁRIO (SIGNUP)
  Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // CRIA A CONTA DO USUÁRIO NO FIREBASE AUTH
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      User? firebaseUser = userCredential.user; // USUÁRIO AUTENTICADO NO FIREBASE

      if (firebaseUser != null) {
        // CRIA O DOCUMENTO DE PERFIL DO USUÁRIO NO FIRESTORE
        UserModel newUser = UserModel(
          uid: firebaseUser.uid, 
          email: firebaseUser.email!, 
          name: name, 
          createdAt: DateTime.now(),
        );

        // SALVA O MODELO DO USUÁRIO NO FIRESTORE
        await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toMap());
        return newUser;
      }
    } on FirebaseAuthException {
      rethrow; // RELANÇA PARA O CONTROLLER TRATAR O ERRO
    } catch (e) {
      print('Erro inesperado no cadastro: $e');
      rethrow; // RELANÇA PARA O CONTROLLER
    }
    return null; // CASO FIREBASEUSER SEJA NULO INESPERADAMENTE
  }

  // MÉTODO PARA LOGIN DE USUÁRIO (SIGNIN)
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // AUTENTICA O USUÁRIO NO FIREBASE AUTH
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // BUSCA O PERFIL DO USUÁRIO NO FIRESTORE
        DocumentSnapshot doc = await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (doc.exists) {
          // CONVERTE O MAP DO FIRESTORE PARA O USERMODEL
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        } else {
          print('Perfil do usuário não encontrado no Firestore para ${firebaseUser.uid}');
          return null;
        }
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      print('Erro inesperado no login: $e');
      rethrow;
    }
    return null;
  }

  // MÉTODO DE LOGOUT DO USUÁRIO (LOGOUT)
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // MÉTODO PARA BUSCAR PERFIL DO USUÁRIO NO FIRESTORE (USADO PELO AUTH PROVIDER)
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar perfil do usuário no Firestore: $e');
      return null;
    }
  }

  // --- NOVO: MÉTODO UPDATE
  // Atualiza os dados do perfil de um usuário no Firestore
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      // Usamos .doc(uid).update() para editar os campos do documento do usuário
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Erro ao atualizar perfil do usuário: $e');
      rethrow;
    }
  }

  // --- NOVO: MÉTODO DELETE
  // Exclui a conta de um usuário tanto do Authentication quanto do Firestore
  Future<void> deleteUserAccount() async {
    try {
      // Pega o usuário atualmente logado no Auth
      final User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Nenhum usuário logado para excluir.');
      }

      final String uid = user.uid;

      // Etapa 1: Excluir o documento do perfil no Firestore
      await _firestore.collection('users').doc(uid).delete();

      // Etapa 2: Excluir o registro de autenticação do usuário
      await user.delete();
    } on FirebaseAuthException catch (e) {
      // Trata erros específicos do Auth
      print('Erro de autenticação ao excluir conta: ${e.code}');
      if (e.code == 'requires-recent-login') {
        throw Exception('Por segurança, faça login novamente antes de excluir sua conta.');
      }
      rethrow;
    } catch (e) {
      print('Erro ao excluir conta de usuário: $e');
      rethrow;
    }
  }
}
