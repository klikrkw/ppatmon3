import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newklikrkw/utils/dio.dart';

Future<String?> uploadImage({
  required File image,
  required String folder,
  String url = '/upload-image',
  Function(double progress)? onProgress,
}) async {
  final storage = const FlutterSecureStorage();
  final String tokenKey = 'auth_token';
  String? token = await storage.read(key: tokenKey);

  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      image.path,
      filename: image.path.split('/').last,
    ),
    'folder': folder,
  });

  if (token == null) return null;
  final response = await dio.post(
    url,
    data: formData,
    options: Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    ),
    onSendProgress: (sent, total) {
      if (total > 0) {
        onProgress?.call(sent / total);
      }
    },
  );

  return response.data['data']['url'];
}
