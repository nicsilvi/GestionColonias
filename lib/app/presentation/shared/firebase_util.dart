import 'package:autentification/app/domain/models/user_model.dart'
    show UserModel;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveUserToFirestore(UserModel user) async {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  await usersCollection.doc(user.id).set(user.toJson());
}

Stream<UserModel?> getUserFromFirestore(String userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) {
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  });
}

Future<void> updateUserInFirestore(UserModel user) async {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  await usersCollection.doc(user.id).update(user.toJson());
}

Future<void> deleteUserFromFirestore(String userId) async {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  await usersCollection.doc(userId).delete();
}

Future<String?> manageImageInFirestore({
  required String userId,
  String? imageUrl,
}) async {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  if (imageUrl != null) {
    await usersCollection.doc(userId).update({
      'profileImage': imageUrl,
    });
    return imageUrl;
  } else {
    final doc = await usersCollection.doc(userId).get();
    if (doc.exists) {
      return doc.data()?['profileImage'] as String?;
    }
    return null;
  }
}
