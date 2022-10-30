import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserDetails extends Equatable {
  UserDetails(
      {required this.username,
      required this.avatarPath,
      required this.saved,
      required this.level,
      required this.points}) {}

  final String username;

  final String avatarPath;

  final List<String>? saved;

  final int level;

  final int points;

  factory UserDetails.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDetails(
      username: data?['username'] as String,
      avatarPath: data?['avatarPath'] as String,
      saved:
          data?['saved'] is Iterable ? List<String>.from(data?['regions']) : [],
      level: data?['level'] as int,
      points: data?['points'] as int,
    );
  }

  @override
  List<Object?> get props => [username, avatarPath, saved, level, points];
}
