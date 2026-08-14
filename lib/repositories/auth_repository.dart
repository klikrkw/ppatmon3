import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/models/user_model.dart';
import 'package:newklikrkw/services/auth_service.dart';
// import 'package:newklikrkw/services/biometric_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  static const String _rememberMeKey = 'remember_me';

  static const String _biometricEnabledKey = 'biometric_login_enabled';

  static const String _biometricTokenKey = 'biometric_auth_token';
  static const _refreshTokenKey = 'refresh_token';

  // ============================================================
  // LOGIN
  // ============================================================

  Future<UserModel> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    final data = await _authService.login(email, password);

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'App gagal terhubung ke server');
    }

    final user = UserModel.fromJson(data['data']);

    // Session token
    await _storage.write(key: _tokenKey, value: user.token);
    await _storage.write(key: _refreshTokenKey, value: user.refreshToken);
    // Remember Me
    await setRememberMe(rememberMe);

    return user;
  }

  // ============================================================
  // TOKEN
  // ============================================================

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();

    return token != null && token.isNotEmpty;
  }

  // ============================================================
  // REMEMBER ME
  // ============================================================

  Future<bool> isRememberMeEnabled() async {
    final value = await _storage.read(key: _rememberMeKey);

    return value == 'true';
  }

  Future<void> setRememberMe(bool value) async {
    await _storage.write(key: _rememberMeKey, value: value.toString());
  }

  Future<void> disableRememberMe() async {
    await _storage.delete(key: _rememberMeKey);
  }

  // ============================================================
  // USER
  // ============================================================

  Future<UserModel?> getUser() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final data = await _authService.getUser(token);

      if (data['success'] != true) {
        return null;
      }

      return UserModel.fromJson(data['data']);
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // USERS
  // ============================================================

  Future<List<User>> getUsers() async {
    final token = await getToken();

    if (token == null) {
      return [];
    }

    final data = await _authService.getUsers(token);

    return data.map((e) => User.fromJson(e)).toList();
  }

  // ============================================================
  // BIOMETRIC
  // ============================================================

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);

    return value == 'true';
  }

  Future<void> enableBiometric() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);

    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('Refresh token tidak tersedia');
    }

    await _storage.write(key: _biometricEnabledKey, value: 'true');
  }

  Future<void> disableBiometric() async {
    // await _storage.delete(key: _biometricTokenKey);
    await _storage.delete(key: _biometricEnabledKey);
  }

  Future<UserModel?> loginWithBiometric() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      // ==========================================
      // Request access token baru
      // ==========================================

      final data = await _authService.refreshToken(refreshToken);
      if (data['success'] != true) {
        await disableBiometric();

        return null;
      }

      final responseData = data['data'];

      final newAccessToken = responseData['token'];
      final newRefreshToken = responseData['refresh_token'];

      if (newAccessToken == null || newAccessToken.toString().isEmpty) {
        await disableBiometric();
        return null;
      }

      // ==========================================
      // Simpan access token baru
      // ==========================================

      await _storage.write(key: _tokenKey, value: newAccessToken.toString());
      await _storage.write(
        key: _refreshTokenKey,
        value: newRefreshToken.toString(),
      );

      // ==========================================
      // Ambil user menggunakan access token baru
      // ==========================================

      final userData = await _authService.getUser(newAccessToken.toString());

      if (userData['success'] != true) {
        return null;
      }

      return UserModel.fromJson(userData['data']);
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    final token = await getToken();

    if (token != null) {
      try {
        await _authService.logout(token);
      } catch (_) {}
    }

    // Hapus session aktif.
    await _storage.delete(key: _tokenKey);

    // Biometric TIDAK dihapus.
    //
    // Jadi setelah logout:
    //
    // Email/password -> login normal
    // Fingerprint     -> tetap bisa digunakan
  }

  // ============================================================
  // CLEAR ALL AUTH
  // ============================================================

  Future<void> clearAllAuth() async {
    await _storage.delete(key: _tokenKey);

    await _storage.delete(key: _rememberMeKey);

    await _storage.delete(key: _biometricTokenKey);

    await _storage.delete(key: _biometricEnabledKey);
  }

  Future<void> clearSessionToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
