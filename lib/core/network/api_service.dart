import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  // =========================
  // GET
  // =========================

  Future<Response<dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) async {
    return await dio.get(
      endpoint,
      queryParameters: queryParameters,
    );
  }

  // =========================
  // POST
  // =========================

  Future<Response<dynamic>> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    return await dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  // =========================
  // PUT
  // =========================

  Future<Response<dynamic>> put(
      String endpoint, {
        dynamic data,
      }) async {
    return await dio.put(
      endpoint,
      data: data,
    );
  }

  // =========================
  // PATCH
  // =========================

  Future<Response<dynamic>> patch(
      String endpoint, {
        dynamic data,
      }) async {
    return await dio.patch(
      endpoint,
      data: data,
    );
  }

  // =========================
  // DELETE
  // =========================

  Future<Response<dynamic>> delete(
      String endpoint, {
        dynamic data,
      }) async {
    return await dio.delete(
      endpoint,
      data: data,
    );
  }
}