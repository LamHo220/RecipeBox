import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserDetails extends Equatable {
  const UserDetails(
      {required this.id,
      required this.description,
      required this.level,
      required this.points,
      required this.exp,
      required this.follows,
      required this.favorites,
      required this.username});

  final String id;

  final String description;

  final int level;

  final int exp;

  final int points;

  final List<String> follows;

  final List<String> favorites;

  final String username;

  static const empty = UserDetails(
      id: '',
      description: '',
      level: 0,
      points: 0,
      exp: 0,
      follows: [],
      favorites: [],username:'');

  factory UserDetails.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDetails(
      id: data?['id'] as String,
      description: data?['description'] as String,
      exp: data?['exp'],
      level: data?['level'],
      points: data?['points'],
      follows: data?['follows'] is Iterable
          ? List<String>.from(data?['follows'])
          : [],
      favorites: data?['favorites'] is Iterable
          ? List<String>.from(data?['favorites'])
          : [],
          username: data?['username'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "description": description,
      "exp": exp,
      "level": level,
      "points": points,
      "username": username,
    };
  }

  @override
  List<Object> get props =>
      [id, description, exp, level, points, favorites, follows, username];
}
