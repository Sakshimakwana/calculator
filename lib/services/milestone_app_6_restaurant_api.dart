import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';


class MilestoneApp6RestaurantApi {
  Map<String, String> _headers(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // ============================================================
  // GET NEARBY RESTAURANTS
  // ============================================================

  Future<List<Map<String, dynamic>>> fetchNearbyRestaurants({
    required String token,
    required int addressId,
    int page = 1,
    bool openNow = false,
  }) async {
    if (addressId <= 0) {
      throw Exception('Invalid address ID.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}'
          '${ApiConstants.nearbyRestaurants}',
    ).replace(
      queryParameters: {
        'page': page.toString(),
        'address_id': addressId.toString(),
        'open_now': openNow.toString(),
      },
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('       NEARBY RESTAURANTS API             ');
    debugPrint('==========================================');
    debugPrint('METHOD: GET');
    debugPrint('ADDRESS ID: $addressId');
    debugPrint('URL: $uri');
    debugPrint('==========================================');

    final response = await http.get(
      uri,
      headers: _headers(token),
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('   NEARBY RESTAURANTS RESPONSE            ');
    debugPrint('==========================================');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RESPONSE BODY:');
    debugPrint(response.body);
    debugPrint('==========================================');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch nearby restaurants: '
            '${response.statusCode}\n'
            '${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Invalid nearby restaurants response.',
      );
    }

    // We will map the exact API response
    // after checking your actual response.
    final data = decoded['data'];

    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
      )
          .toList();
    }

    return [];
  }
}