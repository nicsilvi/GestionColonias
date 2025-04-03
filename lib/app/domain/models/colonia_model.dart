import 'package:cloud_firestore/cloud_firestore.dart';

class ColoniaModel {
  final String id;
  final DateTime createdAt;
  final GeoPoint location;
  final List<String> cats;
  final List<String>? comments;

  ColoniaModel(
      {required this.id,
      required this.createdAt,
      required this.location,
      required this.cats,
      this.comments});

  ColoniaModel copyWith({
    String? id,
    DateTime? createdAt,
    GeoPoint? location,
    List<String>? cats,
    List<String>? comments,
  }) =>
      ColoniaModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        location: location ?? this.location,
        cats: cats ?? this.cats,
        comments: comments ?? this.comments,
      );

  factory ColoniaModel.fromJson(Map<String, dynamic> json) {
    return ColoniaModel(
      id: json["id"] ?? "",
      createdAt: json["createdAt"] == null
          ? DateTime.now()
          : json["createdAt"].toDate(),
      location: json["location"] ?? GeoPoint(0, 0),
      cats: List<String>.from(json["catIds"] ?? []),
      comments: List<String>.from(json["comments"] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": Timestamp.fromDate(createdAt),
        "location": location,
        "cats": cats,
        "comments": comments,
      };
}
