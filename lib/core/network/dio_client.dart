import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/auth_storage.dart';

class DioClient {
  DioClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,

      connectTimeout:
      const Duration(seconds: 30),

      receiveTimeout:
      const Duration(seconds: 30),

      sendTimeout:
      const Duration(seconds: 30),

      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (
          options,
          handler,
          ) {
        final token = AuthStorage.token;

        if (token != null &&
            token.isNotEmpty) {
          options.headers['Authorization'] =
          'Bearer $token';
        }

        handler.next(options);
      },
    ),
  );
}