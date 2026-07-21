import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future getToken() async {
  const tokenKey = 'auth_token';
  final storage = const FlutterSecureStorage();
  String? token = await storage.read(key: tokenKey);
  return token;
}
