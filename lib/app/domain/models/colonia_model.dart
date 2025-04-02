import 'package:autentification/app/domain/models/cat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ColoniaModel {
  final String id;
  final DateTime createdAt;
  final GeoPoint location;
  final List<String> cats;

  ColoniaModel(
      {required this.id,
      required this.createdAt,
      required this.location,
      required this.cats});

  ColoniaModel copyWith({
    String? id,
    DateTime? createdAt,
    GeoPoint? location,
    List<String>? cats,
  }) =>
      ColoniaModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        location: location ?? this.location,
        cats: cats ?? this.cats,
      );

  factory ColoniaModel.fromJson(Map<String, dynamic> json) {
    return ColoniaModel(
      id: json["id"],
      createdAt: json["createdAt"] == null
          ? DateTime.now()
          : json["createdAt"].toDate(),
      location: json["location"] ? json["location"] : GeoPoint(0, 0),
      cats: List<String>.from(json["catIds"] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": Timestamp.fromDate(createdAt),
        "location": location,
        "cat": cats,
      };
}
