import '../core/constants/api_constants.dart';
import '../core/network/api_service.dart';
import '../models/auth/register_request_model.dart';
import '../models/auth/register_response_model.dart';
import '../models/auth/login_response_model.dart';
import '../models/auth/login_request_model.dart';


class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<RegisterResponseModel> register(
      RegisterRequestModel request,
      ) async {
    final response = await apiService.post(
      ApiConstants.register,
      data: request.toJson(),
    );

    final data = Map<String, dynamic>.from(
      response.data as Map,
    );

    return RegisterResponseModel.fromJson(data);
  }
  Future<LoginResponseModel> login(
      LoginRequestModel request,
      ) async {
    final response = await apiService.post(
      ApiConstants.login,
      data: request.toJson(),
    );

    final data = Map<String, dynamic>.from(
      response.data as Map,
    );

    return LoginResponseModel.fromJson(data);
  }
  Future<void> logout() async {
    await apiService.post(
      ApiConstants.logout,
    );
  }
}