import '../core/constants/api_constants.dart';
import '../core/network/api_service.dart';
import '../models/auth/register_request_model.dart';
import '../models/auth/register_response_model.dart';

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
}