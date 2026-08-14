// import 'package:newklikrkw/models/role.dart';

import 'package:newklikrkw/models/role.dart';

class UserModel {
  final int id;
  final String token;
  final String refreshToken;
  final String email;
  final String name;
  final bool isAdmin;
  final List<Role>? roles;
  final List<String>? permissions;

  UserModel({
    required this.id,
    required this.token,
    required this.refreshToken,
    required this.email,
    required this.name,
    this.isAdmin = false,
    this.permissions,
    this.roles,
  });
  bool hasPermissions(String permission) =>
      permissions?.contains(permission) ?? false;
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'] ?? 0,
      token: json['token'] ?? '',
      email: json['user']['email'] ?? '',
      name: json['user']['name'] ?? '',
      isAdmin: json['user']['is_admin'] ?? false,
      permissions: json['user']['permissions'] != null
          ? List<String>.from(json['user']['permissions'])
          : null,
      roles: json['user']['roles'] != null
          ? List<Role>.from(json['user']['roles'].map((x) => Role.fromJson(x)))
          : null,
      refreshToken: json['refresh_token'] ?? '',
    );
  }
}
