import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final DateTime createdAt;
  final String email;
  final String firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.createdAt,
    this.lastName,
    this.phoneNumber,
    this.profileImage,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? createdAt,
    String? profileImage,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        createdAt: createdAt ?? this.createdAt,
        profileImage: profileImage ?? this.profileImage,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"] ?? '',
      firstName: json["firstName"] ?? '',
      lastName: json["lastName"],
      phoneNumber: json["phoneNumber"],
      createdAt: json["createdAt"] == null
          ? DateTime.now()
          : json["createdAt"].toDate(),
      profileImage: json["profileImage"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "createdAt": Timestamp.fromDate(createdAt),
        if (lastName != null) "lastName": lastName,
        if (phoneNumber != null) "phoneNumber": phoneNumber,
        if (profileImage != null) "profileImage": profileImage,
      };
}
