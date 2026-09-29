import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class MilestoneApp6RestaurantApi {
  // ============================================================
  // HEADERS
  // ============================================================

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
    bool includeMenus = false,
  }) async {
    if (token.trim().isEmpty) {
      throw Exception(
        'Authentication token is missing.',
      );
    }

    if (addressId <= 0) {
      throw Exception(
        'Invalid selected address ID.',
      );
    }

    // ==========================================================
    // BUILD QUERY
    // ==========================================================

    final queryParameters = <String, String>{
      'page': page.toString(),
      'address_id': addressId.toString(),
    };

    // Only send open_now when required.
    if (openNow) {
      queryParameters['open_now'] = 'true';
    }

    // Get restaurant categories + food items.
    if (includeMenus) {
      queryParameters['include'] = 'menus.menuItems';
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}'
          '${ApiConstants.nearbyRestaurants}',
    ).replace(
      queryParameters: queryParameters,
    );

    // ==========================================================
    // DEBUG
    // ==========================================================

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('       NEARBY RESTAURANTS API             ');
    debugPrint('==========================================');
    debugPrint('METHOD: GET');
    debugPrint('ADDRESS ID: $addressId');
    debugPrint('OPEN NOW: $openNow');
    debugPrint('INCLUDE MENUS: $includeMenus');
    debugPrint('URL: $uri');
    debugPrint('==========================================');

    // ==========================================================
    // API CALL
    // ==========================================================

    late final http.Response response;

    try {
      response = await http
          .get(
        uri,
        headers: _headers(token),
      )
          .timeout(
        const Duration(seconds: 30),
      );
    } on TimeoutException {
      throw Exception(
        'Nearby restaurant API request timed out.',
      );
    } catch (e) {
      throw Exception(
        'Unable to connect to restaurant server.\n$e',
      );
    }

    // ==========================================================
    // RESPONSE
    // ==========================================================

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('   NEARBY RESTAURANTS RESPONSE            ');
    debugPrint('==========================================');
    debugPrint(
      'STATUS CODE: ${response.statusCode}',
    );
    debugPrint('RESPONSE BODY:');
    debugPrint(response.body);
    debugPrint('==========================================');

    // ==========================================================
    // STATUS
    // ==========================================================

    if (response.statusCode == 401) {
      throw Exception(
        'Session expired. Please login again.',
      );
    }

    if (response.statusCode == 422) {
      throw Exception(
        'Invalid nearby restaurant request.\n'
            '${response.body}',
      );
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch nearby restaurants.\n'
            'Status: ${response.statusCode}\n'
            '${response.body}',
      );
    }

    if (response.body.trim().isEmpty) {
      return <Map<String, dynamic>>[];
    }

    // ==========================================================
    // DECODE
    // ==========================================================

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Invalid nearby restaurant response format.',
      );
    }

    // ==========================================================
    // DATA
    // ==========================================================

    final rawData = decoded['data'];

    if (rawData is! List) {
      return <Map<String, dynamic>>[];
    }

    return rawData
        .whereType<Map>()
        .map(
          (item) => Map<String, dynamic>.from(item),
    )
        .toList();
  }
}