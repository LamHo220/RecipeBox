import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserDetails extends Equatable {
  const UserDetails(
      {required this.id,
      required this.description,
      required this.favorites,
      required this.privateRecipes,
      required this.publicRecipes,
      required this.level,
      required this.points,
      required this.exp,
      required this.follows});

  final String id;

  final String description;

  final List<String> favorites;

  final List<String> privateRecipes;

  final List<String> publicRecipes;

  final int level;

  final int exp;

  final int points;

  final List<String> follows;

  static const empty = UserDetails(
      id: '',
      description: '',
      favorites: [],
      privateRecipes: [],
      publicRecipes: [],
      level: 0,
      points: 0,
      exp: 0,
      follows: []);

  factory UserDetails.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDetails(
      id: data?['id'] as String,
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
      follows: data?['follows'] is Iterable
          ? List<String>.from(data?['follows'])
          : [],
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
