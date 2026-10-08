import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/auth_storage/auth_storage.dart';
import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

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