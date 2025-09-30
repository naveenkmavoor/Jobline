import 'package:equatable/equatable.dart';

enum AccType { recruiter, candidate, none }

class User extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final AccType? accType;
  final String? token;

  const User({
    required this.id,
    this.name,
    this.email,
    this.accType,
    this.token,
  });

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, token];
}
