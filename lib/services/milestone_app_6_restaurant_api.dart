import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';

class MilestoneApp6NearbyRestaurantsResponse {
  final List<Map<String, dynamic>> data;

  final int perPage;
  final int count;
  final bool hasMorePages;
  final int currentPage;
  final int recordsLoaded;
  final int lastPage;
  final int total;

  final String? previousPageUrl;
  final String? nextPageUrl;

  const MilestoneApp6NearbyRestaurantsResponse({
    required this.data,
    required this.perPage,
    required this.count,
    required this.hasMorePages,
    required this.currentPage,
    required this.recordsLoaded,
    required this.lastPage,
    required this.total,
    this.previousPageUrl,
    this.nextPageUrl,
  });
}

class MilestoneApp6RestaurantApi {
  Map<String, String> _headers(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // ==============================================================
  // PAGINATED NEARBY RESTAURANTS API
  // ==============================================================

  Future<MilestoneApp6NearbyRestaurantsResponse>
  fetchNearbyRestaurantsPage({
    required String token,
    required int addressId,
    int page = 1,
    int perPage = 6,
    bool openNow = false,
    bool includeMenus = true,
  }) async {
    if (token.trim().isEmpty) {
      throw Exception('Authentication token is missing.');
    }

    if (addressId <= 0) {
      throw Exception('Invalid selected address ID.');
    }

    if (page <= 0) {
      throw Exception('Invalid restaurant page.');
    }

    if (perPage <= 0) {
      throw Exception('Invalid restaurant per page value.');
    }

    final Map<String, String> queryParameters = {
      'page': page.toString(),
      'per_page': perPage.toString(),
      'address_id': addressId.toString(),
    };

    // Only send open_now when it is required.
    if (openNow) {
      queryParameters['open_now'] = '1';
    }

    if (includeMenus) {
      queryParameters['include'] = 'menus.menuItems';
    }

    final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}'
          '${ApiConstants.nearbyRestaurants}',
    ).replace(
      queryParameters: queryParameters,
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('       NEARBY RESTAURANTS API             ');
    debugPrint('==========================================');
    debugPrint('METHOD: GET');
    debugPrint('ADDRESS ID: $addressId');
    debugPrint('PAGE: $page');
    debugPrint('PER PAGE: $perPage');
    debugPrint('OPEN NOW: $openNow');
    debugPrint('INCLUDE MENUS: $includeMenus');
    debugPrint('URL: $uri');
    debugPrint('==========================================');

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

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('   NEARBY RESTAURANTS RESPONSE            ');
    debugPrint('==========================================');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RESPONSE BODY:');
    debugPrint(response.body);
    debugPrint('==========================================');

    // ============================================================
    // STATUS HANDLING
    // ============================================================

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
      return const MilestoneApp6NearbyRestaurantsResponse(
        data: [],
        perPage: 6,
        count: 0,
        hasMorePages: false,
        currentPage: 1,
        recordsLoaded: 0,
        lastPage: 1,
        total: 0,
      );
    }

    // ============================================================
    // DECODE JSON
    // ============================================================

    final dynamic decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Invalid nearby restaurant response format.',
      );
    }

    // ============================================================
    // RESTAURANT DATA
    // ============================================================

    final dynamic rawData = decoded['data'];

    final List<Map<String, dynamic>> restaurants = [];

    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map) {
          restaurants.add(
            Map<String, dynamic>.from(item),
          );
        }
      }
    }

    // ============================================================
    // PAGINATION
    // ============================================================

    final dynamic rawPagination = decoded['pagination'];

    final Map<String, dynamic> pagination =
    rawPagination is Map
        ? Map<String, dynamic>.from(rawPagination)
        : <String, dynamic>{};

    final int responsePerPage =
        int.tryParse(
          pagination['per_page']?.toString() ?? '',
        ) ??
            perPage;

    final int count =
        int.tryParse(
          pagination['count']?.toString() ?? '',
        ) ??
            restaurants.length;

    final bool hasMorePages =
        pagination['has_more_pages'] == true ||
            pagination['has_more_pages']
                ?.toString()
                .toLowerCase() ==
                'true' ||
            pagination['has_more_pages']?.toString() == '1';

    final int currentPage =
        int.tryParse(
          pagination['current_page']?.toString() ?? '',
        ) ??
            page;

    final int recordsLoaded =
        int.tryParse(
          pagination['records_loaded']?.toString() ?? '',
        ) ??
            restaurants.length;

    final int lastPage =
        int.tryParse(
          pagination['last_page']?.toString() ?? '',
        ) ??
            currentPage;

    final int total =
        int.tryParse(
          pagination['total']?.toString() ?? '',
        ) ??
            recordsLoaded;

    final String? previousPageUrl =
    pagination['previous_page_url']?.toString();

    final String? nextPageUrl =
    pagination['next_page_url']?.toString();

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('        PAGINATION INFORMATION            ');
    debugPrint('==========================================');
    debugPrint('PER PAGE: $responsePerPage');
    debugPrint('COUNT: $count');
    debugPrint('CURRENT PAGE: $currentPage');
    debugPrint('LAST PAGE: $lastPage');
    debugPrint('TOTAL: $total');
    debugPrint('RECORDS LOADED: $recordsLoaded');
    debugPrint('HAS MORE PAGES: $hasMorePages');
    debugPrint('NEXT PAGE URL: $nextPageUrl');
    debugPrint('==========================================');

    return MilestoneApp6NearbyRestaurantsResponse(
      data: restaurants,
      perPage: responsePerPage,
      count: count,
      hasMorePages: hasMorePages,
      currentPage: currentPage,
      recordsLoaded: recordsLoaded,
      lastPage: lastPage,
      total: total,
      previousPageUrl: previousPageUrl,
      nextPageUrl: nextPageUrl,
    );
  }

  // ==============================================================
  // OLD API METHOD
  //
  // Keep this method so your existing Categories screen and
  // other code do not break.
  // ==============================================================

  Future<List<Map<String, dynamic>>> fetchNearbyRestaurants({
    required String token,
    required int addressId,
    int page = 1,
    int perPage = 6,
    bool openNow = false,
    bool includeMenus = true,
  }) async {
    final MilestoneApp6NearbyRestaurantsResponse response =
    await fetchNearbyRestaurantsPage(
      token: token,
      addressId: addressId,
      page: page,
      perPage: perPage,
      openNow: openNow,
      includeMenus: includeMenus,
    );

    return response.data;
  }
}