import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/models/user_model.dart';
import 'package:newklikrkw/services/auth_service.dart';
import 'package:newklikrkw/utils/auth.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();
  final String _tokenKey = 'auth_token';

  Future<UserModel> login(String email, String password) async {
    final data = await _authService.login(email, password);
    UserModel user = UserModel(id: 0, token: '', email: '', name: '');
    if (data['success'] == true) {
      user = UserModel.fromJson(data['data']);
      await _storage.write(key: _tokenKey, value: user.token);
    } else {
      await _storage.delete(key: _tokenKey);
      throw Exception(data['message'] ?? 'Gagal terhubung ke server');
    }
    return user;
  }

  Future<UserModel?> getUser() async {
    String? token = await _storage.read(key: _tokenKey);
    UserModel user = UserModel(id: 0, token: '', email: '', name: '');
    try {
      if (token != null) {
        final data = await _authService.getUser(token);
        if (data['success'] == true) {
          user = UserModel.fromJson(data['data']);
        }
      }
      return user;
    } catch (e) {
      debugPrint('Gagal getUser');
      return null;
      // throw Exception('Gagal terhubung ke server');
    }
  }

  Future<List<User>> getUsers() async {
    String? token = await getToken();
    try {
      if (token != null) {
        final data = await _authService.getUsers(token);
        return data.map((e) => User.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error : ${e.toString()}');
    }
  }

  Future<void> logout() async {
    String? token = await _storage.read(key: _tokenKey);
    if (token != null) {
      await _authService.logout(token);
    }
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    String? token = await _storage.read(key: _tokenKey);
    return token != null;
  }
}
