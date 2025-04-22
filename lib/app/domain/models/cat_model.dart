import 'package:cloud_firestore/cloud_firestore.dart';

class CatModel {
  final String id;
  final String name;
  final String profileImage;
  bool? castrado;
  bool? vacunado;
  final String sexo;
  final String? descripcion;
  final DateTime age;
  final String? coloniaId;
  final List<String>? comments;

  CatModel({
    required this.id,
    required this.name,
    required this.sexo,
    this.descripcion,
    this.castrado,
    this.vacunado,
    required this.profileImage,
    required this.age,
    this.coloniaId,
    this.comments,
  });

  CatModel copyWith({
    String? id,
    String? name,
    String? sexo,
    String? descripcion,
    bool? castrado,
    bool? vacunado,
    String? profileImage,
    DateTime? age,
    String? coloniaId,
    List<String>? comments,
  }) =>
      CatModel(
        id: id ?? this.id,
        name: name ?? this.name,
        sexo: sexo ?? this.sexo,
        descripcion: descripcion ?? this.descripcion,
        castrado: castrado ?? this.castrado,
        vacunado: vacunado ?? this.vacunado,
        profileImage: profileImage ?? this.profileImage,
        age: age ?? this.age,
        comments: comments ?? this.comments,
        coloniaId: coloniaId ?? this.coloniaId,
      );

  factory CatModel.fromJson(Map<String, dynamic> json) {
    return CatModel(
      id: json["id"],
      name: json["name"],
      sexo: json["sexo"],
      descripcion: json["descripcion"],
      castrado: json["castrado"],
      vacunado: json["vacunado"],
      comments: List<String>.from(json["comments"] ?? []),
      profileImage: json["profileImage"],
      age: (json["age"] as Timestamp).toDate(),
      coloniaId: json["coloniaId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sexo": sexo,
        "descripcion": descripcion,
        "castrado": castrado,
        "comments": comments,
        "vacunado": vacunado,
        "profileImage": profileImage,
        "age": Timestamp.fromDate(age),
        "coloniaId": coloniaId,
      };
}
