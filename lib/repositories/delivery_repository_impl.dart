import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../Milestone_app_6/Login/auth_storage/auth_storage.dart';


import '../models/delivery/delivery_response_model.dart';
import 'delivery_repository.dart';

class DeliveryRepositoryImpl
    implements DeliveryRepository {
  // ============================================================
  // HEADERS
  // ============================================================

  Future<Map<String, String>> _headers() async {
    final String? token =
    await AuthStorage.token;

    if (token == null ||
        token.trim().isEmpty) {
      throw Exception(
        'Authentication token is missing. Please login again.',
      );
    }

    return {
      'Authorization':
      'Bearer ${token.trim()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // ============================================================
  // GET ALL DELIVERIES
  //
  // GET /deliveries
  // ============================================================

  @override
  Future<DeliveryResponseModel>
  fetchDeliveries() async {
    final headers = await _headers();

    final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}'
          '${ApiConstants.deliveries}',
    );

    print('');
    print('========================================');
    print('          FETCH DELIVERIES');
    print('========================================');
    print('METHOD: GET');
    print('URL: $uri');
    print('========================================');

    final response = await http
        .get(
      uri,
      headers: headers,
    )
        .timeout(
      const Duration(seconds: 30),
    );

    print(
      'DELIVERIES STATUS: '
          '${response.statusCode}',
    );

    print(
      'DELIVERIES RESPONSE: '
          '${response.body}',
    );

    if (response.statusCode == 401) {
      throw Exception(
        'Session expired. Please login again.',
      );
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        _apiMessage(
          response.body,
          fallback:
          'Unable to fetch deliveries.',
        ),
      );
    }

    final decoded =
    jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Invalid deliveries response.',
      );
    }

    return DeliveryResponseModel.fromJson(
      Map<String, dynamic>.from(decoded),
    );
  }

  // ============================================================
  // GET DELIVERY FOR PARTICULAR ORDER
  // ============================================================

  @override
  Future<DeliveryResponseModel>
  fetchDeliveryForOrder(
      int orderId,
      ) async {
    final response =
    await fetchDeliveries();

    final matchingDeliveries =
    response.data.where(
          (delivery) {
        return delivery.orderId ==
            orderId ||
            delivery.order?.id ==
                orderId;
      },
    ).toList();

    return DeliveryResponseModel(
      success: response.success,
      message: response.message,
      data: matchingDeliveries,
      pagination: response.pagination,
    );
  }

  // ============================================================
  // API MESSAGE
  // ============================================================

  String _apiMessage(
      String body, {
        required String fallback,
      }) {
    try {
      final decoded =
      jsonDecode(body);

      if (decoded is Map &&
          decoded['message'] != null) {
        return decoded['message']
            .toString();
      }
    } catch (_) {}

    return fallback;
  }
}