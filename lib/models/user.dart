import 'package:newklikrkw/models/role.dart';

class User {
  final int id;
  final String? email;
  final String name;
  final bool? isAdmin;
  final List<Role>? roles;
  final List<String>? permissions;

  User({
    this.email,
    required this.name,
    this.roles,
    required this.id,
    this.isAdmin,
    this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      isAdmin: json['is_admin'],
      roles: json['roles'] != null
          ? (json['roles'] as List).map((e) => Role.fromJson(e)).toList()
          : [],
      permissions: json['permissions'] != null
          ? (json['permissions'] as List).map((e) => e.toString()).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'is_admin': isAdmin,
    // 'roles': roles?.map((e) => e).toList(),
    // 'permissions': permissions,
  };
}
