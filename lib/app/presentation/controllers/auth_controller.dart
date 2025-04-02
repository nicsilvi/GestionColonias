import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/user_model.dart';
import '../implements/authentication_impl.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) => AuthenticationRepositoryImpl(),
);

class UserResponse {
  final UserModel? user;
  final String? errorMessage;

  UserResponse({this.user, this.errorMessage});
}

abstract class AuthenticationRepository {
  Future<UserResponse?> signIn(
    String email,
    String password,
    WidgetRef ref,
  );

  Future<UserResponse?> register(
      {required String email,
      required String firstname,
      String? lastname,
      required String password,
      required WidgetRef ref});

  Future<bool> signOut();
  Future<UserModel?> getUser(String userId);

  Stream<UserModel?> isUserLoggedIn();

  // Definir el estado de autenticación

  //Future<UserModel?> getUser(String userId);
  //User? get currentUser;
  //Future<FirebaseResponse> sendPasswordResetEmail(String email);
  //Future<FirebaseResponse> deleteUserAccount(String password);

  //Future<bool> userExists(String email);

  //Future<FirebaseResponse> updateUserInfo(UserModel user);
}
