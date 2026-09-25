import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/auth/register_request_model.dart';
import '../models/auth/register_response_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository repository;

  AuthController(this.repository);

  bool isLoading = false;

  String? errorMessage;

  RegisterResponseModel? registerResponse;

  Future<bool> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    registerResponse = null;

    notifyListeners();

    try {
      final request = RegisterRequestModel(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );

      final response = await repository.register(request);

      registerResponse = response;

      isLoading = false;

      notifyListeners();

      return response.success;
    } on DioException catch (e) {
      isLoading = false;

      final responseData = e.response?.data;

      if (responseData is Map) {
        errorMessage =
            responseData['message']?.toString() ??
                'Registration failed';
      } else {
        errorMessage = 'Registration failed';
      }

      notifyListeners();

      return false;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Something went wrong. Please try again.';

      notifyListeners();

      return false;
    }
  }
}