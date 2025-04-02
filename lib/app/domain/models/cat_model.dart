import 'package:cloud_firestore/cloud_firestore.dart';

class CatModel {
  final String id;
  final String name;
  final String profileImage;
  final DateTime age;
  final String coloniaId;

  CatModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.age,
    required this.coloniaId,
  });

  CatModel copyWith({
    String? id,
    String? name,
    String? profileImage,
    DateTime? age,
    String? coloniaId,
  }) =>
      CatModel(
        id: id ?? this.id,
        name: name ?? this.name,
        profileImage: profileImage ?? this.profileImage,
        age: age ?? this.age,
        coloniaId: coloniaId ?? this.coloniaId,
      );

  factory CatModel.fromJson(Map<String, dynamic> json) {
    return CatModel(
      id: json["id"],
      name: json["name"],
      profileImage: json["profileImage"],
      age: (json["age"] as Timestamp).toDate(),
      coloniaId: json["coloniaId"], // ID de la colonia asociada
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profileImage": profileImage,
        "age": Timestamp.fromDate(age),
        "coloniaId": coloniaId, // Guardar ID de la colonia asociada
      };
}
