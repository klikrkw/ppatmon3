import 'dart:io';
import 'package:dio/dio.dart';

// final myBaseUrl = Platform.isAndroid
//     ? 'http://10.0.2.2:8000'
//     : 'http://127.0.0.1:8000';
final myBaseUrl = Platform.isAndroid
    ? 'https://newklikrkw.masbahtr.com'
    : 'https://newklikrkw.masbahtr.com';

final Dio dio = Dio(
  BaseOptions(
    // Gunakan 10.0.2.2 untuk Android Emulator, 127.0.0.1 untuk iOS
    // baseUrl: Platform.isAndroid
    //     ? 'http://10.0.2.2:8000/api/v1'
    //     : 'http://127.0.0.1:8000/api/v1',
    baseUrl: Platform.isAndroid
        ? 'https://newklikrkw.masbahtr.com/api/v1'
        : 'https://newklikrkw.masbahtr.com/api/v1',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
);
