import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  // CONVERTE UM MAP VINDO DO FIRESTORE, PARA UM OBJ USERMODEL (LEITURA DE DADOS DO FIRESTORE)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String, 
      email: data['email'] as String, 
      name: data['name'] as String, 
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // CONVERTE UM OBJ USERMODEL, PARA UM MAP DO FIRESTORE (SALVAR DADOS NO FIRESTORE)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

