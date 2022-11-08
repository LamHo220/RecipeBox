import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class UserDetails extends Equatable {
  UserDetails(this.id,
      {required this.description,
      required this.favorites,
      required this.privateRecipes,
      required this.publicRecipes,
      required this.level,
      required this.points,
      required this.exp});

  final String id;

  final String description;

  final List<String> favorites;

  final List<String> privateRecipes;

  final List<String> publicRecipes;

  final int level;

  final int exp;

  final int points;

  factory UserDetails.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDetails(
      data?['id'] as String,
      description: data?['description'] as String,
      favorites: data?['favorites'] is Iterable
          ? List<String>.from(data?['favorites'])
          : [],
      privateRecipes: data?['privateRecipes'] is Iterable
          ? List<String>.from(data?['privateRecipes'])
          : [],
      publicRecipes: data?['publicRecipes'] is Iterable
          ? List<String>.from(data?['publicRecipes'])
          : [],
      exp: int.parse(data?['exp']),
      level: int.parse(data?['level']),
      points: int.parse(data?['points']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "description": description,
      "favorites": favorites,
      "privateRecipes": privateRecipes,
      "publicRecipes": publicRecipes,
      "exp": exp,
      "level": level,
      "points": points,
    };
  }

  @override
  List<Object> get props => [
        id,
        description,
        favorites,
        privateRecipes,
        publicRecipes,
        exp,
        level,
        points
      ];
}
