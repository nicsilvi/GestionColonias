import 'package:cloud_firestore/cloud_firestore.dart';

class ColoniaModel {
  final String id;
  final DateTime createdAt;
  final String description;
  final GeoPoint location;
  final String address;
  DateTime? lastVisit;
  final List<String> cats;
  final List<String>? comments;

  ColoniaModel(
      {required this.id,
      required this.createdAt,
      required this.address,
      required this.description,
      this.lastVisit,
      required this.location,
      required this.cats,
      this.comments});

  ColoniaModel copyWith({
    String? id,
    DateTime? createdAt,
    String? address,
    String? description,
    DateTime? lastVisit,
    GeoPoint? location,
    List<String>? cats,
    List<String>? comments,
  }) =>
      ColoniaModel(
        id: id ?? this.id,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        location: location ?? this.location,
        lastVisit: lastVisit ?? this.lastVisit,
        address: address ?? this.address,
        cats: cats ?? this.cats,
        comments: comments ?? this.comments,
      );

  factory ColoniaModel.fromJson(Map<String, dynamic> json) {
    return ColoniaModel(
      id: json["id"] ?? "",
      description: json["description"] ?? "",
      address: json["address"] ?? "",
      lastVisit: json["lastVisit"] == null
          ? null
          : (json["lastVisit"] as Timestamp).toDate(),
      createdAt: json["createdAt"] == null
          ? DateTime.now()
          : json["createdAt"].toDate(),
      location: json["location"] ?? const GeoPoint(0, 0),
      cats: List<String>.from(json["catIds"] ?? []),
      comments: List<String>.from(json["comments"] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "description": description,
        "lastVisit": lastVisit == null ? null : Timestamp.fromDate(lastVisit!),
        "createdAt": Timestamp.fromDate(createdAt),
        "location": location,
        "cats": cats,
        "comments": comments,
      };
}
