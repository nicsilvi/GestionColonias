/*implementación para acceder a API, sigIn, signOut, getUser, delete, userExist, etc
*/

import 'package:autentification/app/presentation/shared/firebase_util.dart'
    show getUserFromFirestore, saveUserToFirestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/assets.dart';
import '../../domain/models/user_model.dart';
import '../controllers/auth_controller.dart';
import '../shared/utils.dart';

final errorMessageProvider = StateProvider<String?>((ref) => null);

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl();

  //@override
  //User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Future<UserResponse?> signIn(
      String email, String password, WidgetRef ref) async {
    try {
      final credentials =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user == null) {
        return UserResponse(errorMessage: "Error, user not found");
      }
      final userModel = await getUser(credentials.user!.uid);
      if (userModel == null) {
        return UserResponse(errorMessage: "Error, user not found");
      }
      return UserResponse(user: userModel);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      //
      if (e.message == "The email address is badly formatted.") {
        errorMessage = "El correo electrónico no es válido";
      } else if (e.message ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        errorMessage = "Usuario o contraseña incorrecta";
      } else if ((e.message ==
              "The password is invalid or the user does not have a password.") ||
          (e.message ==
              "The supplied auth credential is incorrect, malformed or has expired.")) {
        errorMessage = "Usuario o contraseña incorrecta";
      } else {
        errorMessage =
            e.message ?? "Ha ocurrido un error inesperado, vuelva a intentarlo";
      }
      ref.read(errorMessageProvider.notifier).state = errorMessage;
      return UserResponse(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage =
          "Ha ocurrido un error inesperado, vuelva a intentarlo";
      ref.read(errorMessageProvider.notifier).state = errorMessage;

      return UserResponse(errorMessage: errorMessage);
    }
  }

  @override
  Future<UserResponse?> register({
    required String email,
    required String firstname,
    String? lastname,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      final credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user == null) {
        return null;
      }

      final newUser = UserModel(
        id: credentials.user!.uid,
        email: email,
        firstName: capitalize(firstname),
        lastName: capitalize(lastname ?? ''),
        createdAt: DateTime.now(),
        profileImage: Assets.userIcon1,
      );
      await saveUserToFirestore((newUser));
      print("User created: ${newUser.toJson()}");

      return UserResponse(user: newUser);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == "email-already-in-use") {
        errorMessage = "El correo electrónico ya está en uso";
      } else if (e.code == "invalid-email") {
        errorMessage = "El correo electrónico no es válido";
      } else if (e.code == "weak-password") {
        errorMessage = "La contraseña es demasiado débil";
      } else {
        errorMessage =
            e.message ?? "Ha ocurrido un error inesperado, vuelva a intentarlo";
      }
      debugPrint(e.code);
      ref.read(errorMessageProvider.notifier).state = errorMessage;
      return UserResponse(errorMessage: errorMessage);
    } catch (e) {
      const errorMessage =
          "Ha ocurrido un error inesperado, vuelva a intentarlo";
      ref.read(errorMessageProvider.notifier).state = errorMessage;

      return UserResponse(errorMessage: errorMessage);
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (!doc.exists) return null;
      return UserModel.fromJson(
          doc.data()!); // Usa `data()` para obtener los datos
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

/*
  @override
  Future<FirebaseResponse> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const FirebaseResponse.success();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      return e.code.toFirebaseResponse();
    } catch (e) {
      debugPrint(e.toString());
      return FirebaseResponse.undefined(message: e.toString());
    }
  }

  //Delte user account ---------------------------------------------
  @override
  Future<FirebaseResponse> deleteUserAccount(String password) async {
    if (currentUser == null) return const FirebaseResponse.noCredentials();
    try {
      await currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: currentUser!.email!,
          password: password,
        ),
      );
      final result = await _deleteFirestoreUser(currentUser!.uid);
      if (result == const FirebaseResponse.success()) {
        await currentUser!.delete();
        return const FirebaseResponse.success();
      }
      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      return e.code.toFirebaseResponse();
    } catch (e) {
      debugPrint(e.toString());
      return FirebaseResponse.undefined(message: e.toString());
    }
  }

  Future<FirebaseResponse> _deleteFirestoreUser(String userId) async {
    try {
      final usersCollection =
          FirebaseFirestore.instance.collection(Collections.users);
      DocumentReference docRef = usersCollection.doc(userId);
      await docRef.delete();
      return const FirebaseResponse.success();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.code.toFirebaseResponse();
    }
  }

  @override
  Future<bool> userExists(String email) async {
    try {
      final usersCollection =
          FirebaseFirestore.instance.collection(Collections.users);
      final docs = await usersCollection.where('email', isEqualTo: email).get();
      return docs.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  @override
  Future<FirebaseResponse> updateUserInfo(UserModel user) async {
    try {
      final usersCollection =
          FirebaseFirestore.instance.collection(Collections.users);
      await usersCollection.doc(user.id).update(
            user.toJson(),
          );
      return const FirebaseResponse.success();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.code.toFirebaseResponse();
    }
  }
} */
  @override
  Stream<UserModel?> isUserLoggedIn() async* {
    final userStream = FirebaseAuth.instance.authStateChanges();
    await for (final User? user in userStream) {
      //usuari mno loggejat
      if (user == null) {
        yield null;
      } else {
        try {
          final userDocStream = getUserFromFirestore(user.uid);
          await for (final userModel in userDocStream) {
            if (userModel != null) {
              yield userModel; // Devuelve el modelo completo del usuario
            } else {
              yield null;
            }
          }
        } catch (e) {
          debugPrint("Error al recuperar el usuario: $e");
          yield null;
        }
      }
    }
  }
}
