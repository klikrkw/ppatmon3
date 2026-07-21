// import 'package:newklikrkw/models/role.dart';

class UserModel {
  final int id;
  final String token;
  final String email;
  final String name;
  final bool isAdmin;
  // final List<Role>? roles;

  UserModel({
    required this.id,
    required this.token,
    required this.email,
    required this.name,
    this.isAdmin = false,
    // this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'] ?? 0,
      token: json['token'] ?? '',
      email: json['user']['email'] ?? '',
      name: json['user']['name'] ?? '',
      isAdmin: json['user']['is_admin'] ?? false,
      // roles: json['user']['roles'] != null
      //     ? List<Role>.from(json['user']['roles'].map((x) => Role.fromJson(x)))
      //     : null,
    );
  }
}
