import 'package:newklikrkw/models/role.dart';

class User {
  final int id;
  final String? email;
  final String name;
  final bool? isAdmin;
  final List<Role>? roles;

  User({
    this.email,
    required this.name,
    this.roles,
    required this.id,
    this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      isAdmin: json['is_admin'],
      roles: json['roles'] != null
          ? (json['roles'] as List).map((e) => Role.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'is_admin': isAdmin,
  };
}
