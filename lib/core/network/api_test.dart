import 'package:dio/dio.dart';
import 'api_service.dart';
import 'dio_client.dart';
import '../constants/api_constants.dart';

class ApiTest {
  static Future<void> testRegister() async {
    final apiService = ApiService(DioClient.dio);

    try {
      final response = await apiService.post(
        ApiConstants.register,
        data: {
          'full_name': 'Flutter Test User',
          'email': 'fluttertest789@gmail.com',
          'phone_number': '9876543211',
          'password': 'password',
        },
      );

      print('==============================');
      print('REGISTER API SUCCESS');
      print('Status Code: ${response.statusCode}');
      print('Response: ${response.data}');
      print('==============================');
    } on DioException catch (e) {
      print('==============================');
      print('REGISTER API ERROR');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('Message: ${e.message}');
      print('==============================');
    } catch (e) {
      print('==============================');
      print('REGISTER API ERROR');
      print('Error: $e');
      print('==============================');
    }
  }
}