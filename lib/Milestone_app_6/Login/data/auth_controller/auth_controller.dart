import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../models/login_request_model.dart';
import '../../models/login_response_model.dart';
import '../../../Register/models/register_request_model.dart';
import '../../../Register/models/register_response_model.dart';
import '../auth_repo/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository repository;
  LoginResponseModel? loginResponse;
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

    print('');
    print('========================================');
    print('        REGISTER API STARTED');
    print('========================================');
    print('Full Name: $fullName');
    print('Email: $email');
    print('Phone: $phoneNumber');
    print('Password: ********');
    print('Calling: POST /register');

    try {
      final request = RegisterRequestModel(
        fullName: fullName.trim(),
        email: email.trim(),
        phoneNumber: phoneNumber.trim(),
        password: password,
      );

      final response = await repository.register(request);

      registerResponse = response;

      print('');
      print('========================================');
      print('        REGISTER API SUCCESS');
      print('========================================');
      print('Status: SUCCESS');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('');
      print('------------- USER DATA -------------');
      print('User ID: ${response.data.id}');
      print('Full Name: ${response.data.fullName}');
      print('Email: ${response.data.email}');
      print('Phone: ${response.data.phoneNumber}');
      print('========================================');
      print('           REGISTER COMPLETE');
      print('========================================');
      print('');

      isLoading = false;
      notifyListeners();

      return response.success;
    } on DioException catch (e) {
      isLoading = false;

      print('');
      print('========================================');
      print('         REGISTER API FAILED');
      print('========================================');
      print('Status Code: ${e.response?.statusCode}');
      print('Error: ${e.message}');
      print('Response: ${e.response?.data}');
      print('========================================');
      print('');

      final responseData = e.response?.data;

      if (responseData is Map) {
        final errors = responseData['errors'];

        if (errors is Map) {
          final List<String> errorMessages = [];

          for (final entry in errors.entries) {
            final value = entry.value;

            if (value is List && value.isNotEmpty) {
              errorMessages.add(value.first.toString());
            }
          }

          if (errorMessages.isNotEmpty) {
            errorMessage = errorMessages.join('\n');
          } else {
            errorMessage =
                responseData['message']?.toString() ?? 'Registration failed';
          }
        } else {
          errorMessage =
              responseData['message']?.toString() ?? 'Registration failed';
        }
      } else {
        errorMessage = 'Registration failed. Please try again.';
      }

      notifyListeners();
      return false;
    } catch (e) {
      isLoading = false;

      print('');
      print('========================================');
      print('       REGISTER UNKNOWN ERROR');
      print('========================================');
      print('Error: $e');
      print('========================================');
      print('');

      errorMessage = 'Something went wrong. Please try again.';

      notifyListeners();
      return false;
    }
  }
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    loginResponse = null;
    notifyListeners();

    print('');
    print('========================================');
    print('          LOGIN API STARTED');
    print('========================================');
    print('Email: $email');
    print('Password: ********');
    print('Calling: POST /login');

    try {
      final request = LoginRequestModel(
        email: email.trim(),
        password: password,
      );

      final response = await repository.login(request);

      loginResponse = response;

      print('');
      print('========================================');
      print('          LOGIN API SUCCESS');
      print('========================================');
      print('Status: SUCCESS');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('');
      print('------------- USER DATA -------------');
      print('User ID: ${response.data.user.id}');
      print('Full Name: ${response.data.user.fullName}');
      print('Email: ${response.data.user.email}');
      print('Phone: ${response.data.user.phoneNumber}');
      print('');
      print(
        'Access Token Received: '
            '${response.data.accessToken.isNotEmpty}',
      );
      print('Token: ********');
      print('========================================');

      // Save login information
      await AuthStorage.saveLoginData(
        token: response.data.accessToken,
        userId: response.data.user.id,
        fullName: response.data.user.fullName,
        email: response.data.user.email,
        phoneNumber: response.data.user.phoneNumber,
      );

      print('');
      print('------------- AUTH STORAGE -------------');
      print('Token Saved: ${AuthStorage.isLoggedIn}');
      print('Saved User ID: ${AuthStorage.userId}');
      print('Saved Name: ${AuthStorage.fullName}');
      print('Saved Email: ${AuthStorage.email}');
      print('Saved Phone: ${AuthStorage.phoneNumber}');
      print('========================================');
      print('            LOGIN COMPLETE');
      print('========================================');
      print('');

      isLoading = false;
      notifyListeners();

      return response.success;
    } on DioException catch (e) {
      isLoading = false;

      print('');
      print('========================================');
      print('           LOGIN API FAILED');
      print('========================================');
      print('Status Code: ${e.response?.statusCode}');
      print('Error: ${e.message}');
      print('Response: ${e.response?.data}');
      print('========================================');
      print('');

      final responseData = e.response?.data;

      if (responseData is Map) {
        final errors = responseData['errors'];

        if (errors is Map) {
          final List<String> errorMessages = [];

          for (final entry in errors.entries) {
            final value = entry.value;

            if (value is List && value.isNotEmpty) {
              errorMessages.add(value.first.toString());
            }
          }

          if (errorMessages.isNotEmpty) {
            errorMessage = errorMessages.join('\n');
          } else {
            errorMessage =
                responseData['message']?.toString() ?? 'Login failed';
          }
        } else {
          errorMessage =
              responseData['message']?.toString() ?? 'Login failed';
        }
      } else {
        errorMessage = 'Login failed. Please try again.';
      }

      notifyListeners();
      return false;
    } catch (e) {
      isLoading = false;

      print('');
      print('========================================');
      print('         LOGIN UNKNOWN ERROR');
      print('========================================');
      print('Error: $e');
      print('========================================');
      print('');

      errorMessage = 'Something went wrong. Please try again.';

      notifyListeners();
      return false;
    }
  }
  Future<bool> logout() async {
    try {
      print('');
      print('========================================');
      print('          LOGOUT API STARTED');
      print('========================================');

      await repository.logout();

      print('');
      print('========================================');
      print('          LOGOUT API SUCCESS');
      print('========================================');
      print('Status: SUCCESS');
      print('Message: User logged out successfully');
      print('========================================');

      // Clear token and saved user information
      await AuthStorage.clearAuth();

      print('');
      print('------------- AUTH STORAGE CLEARED -------------');
      print('Token Exists: ${AuthStorage.isLoggedIn}');
      print('User ID: ${AuthStorage.userId}');
      print('Full Name: ${AuthStorage.fullName}');
      print('Email: ${AuthStorage.email}');
      print('Phone: ${AuthStorage.phoneNumber}');
      print('========================================');
      print('');

      notifyListeners();

      return true;
    } on DioException catch (e) {
      print('');
      print('========================================');
      print('          LOGOUT API FAILED');
      print('========================================');
      print('Status Code: ${e.response?.statusCode}');
      print('Error: ${e.message}');
      print('Response: ${e.response?.data}');
      print('========================================');
      print('');

      // Even if server logout fails, you can clear local authentication.
      await AuthStorage.clearAuth();

      notifyListeners();

      return false;
    } catch (e) {
      print('');
      print('========================================');
      print('        LOGOUT UNKNOWN ERROR');
      print('========================================');
      print('Error: $e');
      print('========================================');
      print('');

      await AuthStorage.clearAuth();

      notifyListeners();

      return false;
    }
  }

}