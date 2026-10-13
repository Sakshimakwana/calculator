import 'dart:convert';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/models/milestone_app_6_address_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../core/constants/api_constants.dart';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MilestoneApp6AddressApi {
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
  static final Map<String, Future<http.Response>>
  _addressRequests = {};
  static final Map<String, http.Response> _addressResponseCache = {};

  String _addressCacheKey(String token, Uri uri) {
    final tokenHash = sha256.convert(
      utf8.encode(token),
    ).toString();

    final requestHash = sha256.convert(
      utf8.encode(uri.toString()),
    ).toString();

    return 'address_list_cache_${tokenHash}_$requestHash';
  }

  Future<http.Response> _getAddressesWithCache(
      Uri uri,
      String token,
      ) async {
    final key = _addressCacheKey(token, uri);

    // Return the successful response without another API request.
    final cachedResponse = _addressResponseCache[key];

    if (cachedResponse != null) {
      debugPrint('ADDRESS MEMORY CACHE HIT: $uri');
      return cachedResponse;
    }

    // Reuse an existing request if one is already running.
    return _addressRequests.putIfAbsent(key, () async {
      final response = await _performAddressGet(
        uri,
        token,
        key,
      );

      if (response.statusCode == 200) {
        _addressResponseCache[key] = response;
      }

      return response;
    });
  }
  Future<http.Response> _performAddressGet(
      Uri uri,
      String token,
      String key,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(key);

    if (saved != null) {
      try {
        final cached = jsonDecode(saved) as Map<String, dynamic>;
        final body = cached['body'] as String;

        debugPrint('ADDRESS CACHE HIT: $uri');
        return http.Response(body, 200);
      } catch (_) {
        await prefs.remove(key);
      }
    }

    debugPrint('ADDRESS CACHE MISS: $uri');

    final response = await http.get(
      uri,
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      await prefs.setString(
        key,
        jsonEncode({
          'savedAt': DateTime.now().millisecondsSinceEpoch,
          'body': response.body,
        }),
      );
    }

    return response;
  }

  // ============================================================
  // GET ADDRESSES
  // ============================================================

  Future<List<MilestoneApp6Address>> fetchAddresses({
    required String token,
    int page = 1,
    String? search,
  }) async {
    final queryParameters = <String, String>{
      'page': page.toString(),
    };

    if (search != null && search.trim().isNotEmpty) {
      queryParameters['q'] = search.trim();
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}'
          '${ApiConstants.addresses}',
    ).replace(
      queryParameters: queryParameters,
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('          FETCH ADDRESSES API             ');
    debugPrint('==========================================');
    debugPrint('METHOD: GET');
    debugPrint('URL: $uri');
    debugPrint('==========================================');

    final response = await _getAddressesWithCache(
      uri,
      token,
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('       FETCH ADDRESS RESPONSE             ');
    debugPrint('==========================================');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RESPONSE BODY:');
    debugPrint(response.body);
    debugPrint('==========================================');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch addresses: '
            '${response.statusCode}\n'
            '${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Invalid address response.',
      );
    }

    final rawData = decoded['data'];

    if (rawData is! List) {
      return <MilestoneApp6Address>[];
    }

    return rawData
        .whereType<Map>()
        .map(
          (item) => MilestoneApp6Address.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  Future<void> _clearAddressListCache(String token) async {
    final prefs = await SharedPreferences.getInstance();

    final tokenHash = sha256
        .convert(utf8.encode(token))
        .toString();

    final prefix = 'address_list_cache_${tokenHash}_';

    final keys = prefs.getKeys()
        .where((key) => key.startsWith(prefix))
        .toList();

    for (final key in keys) {
      await prefs.remove(key);
      _addressResponseCache.remove(key);
    }

    debugPrint('ADDRESS CACHE CLEARED');
  }

  // ============================================================
  // POST - ADD ADDRESS
  // ============================================================

  Future<MilestoneApp6Address> storeAddress({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final requestBody = Map<String, dynamic>.from(body);

    // Support old key if accidentally passed.
    if ((requestBody['address_line'] == null ||
        requestBody['address_line']
            .toString()
            .trim()
            .isEmpty) &&
        requestBody['address'] != null) {
      requestBody['address_line'] =
          requestBody['address'].toString().trim();
    }

    requestBody.remove('address');

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    final label =
        requestBody['label']?.toString().trim() ?? '';

    final addressLine =
        requestBody['address_line']?.toString().trim() ?? '';

    final city =
        requestBody['city']?.toString().trim() ?? '';

    final state =
        requestBody['state']?.toString().trim() ?? '';

    final pincode =
        requestBody['pincode']?.toString().trim() ?? '';

    if (label.isEmpty) {
      throw Exception(
        'Address label is required.',
      );
    }

    if (addressLine.isEmpty) {
      throw Exception(
        'Address line is required.',
      );
    }

    if (city.isEmpty) {
      throw Exception(
        'City is required.',
      );
    }

    if (state.isEmpty) {
      throw Exception(
        'State is required.',
      );
    }

    if (!RegExp(r'^\d{6}$').hasMatch(pincode)) {
      throw Exception(
        'Pincode must be 6 digits.',
      );
    }

    if (requestBody['latitude'] == null) {
      throw Exception(
        'Latitude is required.',
      );
    }

    if (requestBody['longitude'] == null) {
      throw Exception(
        'Longitude is required.',
      );
    }

    // Backend expects is_default as boolean.
    requestBody['is_default'] =
        requestBody['is_default'] == true;

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}'
          '${ApiConstants.storeAddress}',
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('            STORE ADDRESS                 ');
    debugPrint('==========================================');
    debugPrint('METHOD: POST');
    debugPrint('URL: $uri');
    debugPrint('REQUEST BODY:');
    debugPrint(
      const JsonEncoder.withIndent('  ')
          .convert(requestBody),
    );
    debugPrint('==========================================');

    final response = await http.post(
      uri,
      headers: _headers(token),
      body: jsonEncode(requestBody),
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('       STORE ADDRESS RESPONSE             ');
    debugPrint('==========================================');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RESPONSE BODY:');
    debugPrint(response.body);
    debugPrint('==========================================');

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        'Failed to store address: '
            '${response.statusCode}\n'
            '${response.body}',
      );
    }

    await _clearAddressListCache(token);

    return _parseAddressResponse(
      response.body,
    );
  }

  // ============================================================
  // PUT - UPDATE ADDRESS
  // ============================================================

  Future<MilestoneApp6Address> updateAddress({
    required String token,
    required int addressId,
    required Map<String, dynamic> body,
  }) async {
    if (addressId <= 0) {
      throw Exception(
        'Invalid address ID.',
      );
    }

    final requestBody =
    Map<String, dynamic>.from(body);

    // Make sure backend receives boolean.
    requestBody['is_default'] =
        requestBody['is_default'] == true;

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}'
          '${ApiConstants.updateAddress(addressId)}',
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('            UPDATE ADDRESS                ');
    debugPrint('==========================================');
    debugPrint('METHOD: PUT');
    debugPrint('ADDRESS ID: $addressId');
    debugPrint('URL: $uri');
    debugPrint('REQUEST BODY:');
    debugPrint(
      const JsonEncoder.withIndent('  ')
          .convert(requestBody),
    );
    debugPrint('==========================================');

    final response = await http.put(
      uri,
      headers: _headers(token),
      body: jsonEncode(requestBody),
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('       UPDATE ADDRESS RESPONSE            ');
    debugPrint('==========================================');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RESPONSE BODY:');
    debugPrint(response.body);
    debugPrint('==========================================');

    if (response.statusCode != 200 &&
    response.statusCode != 201) {
    throw Exception(
    'Failed to update address: '
    '${response.statusCode}\n'
    '${response.body}',
    );
    }

// Clear the old cached address list after a successful update.
    await _clearAddressListCache(token);

    debugPrint('ADDRESS CACHE CLEARED AFTER UPDATE');

    final updatedAddress = _parseAddressResponse(
    response.body,
    );

    debugPrint('UPDATED ADDRESS ID: ${updatedAddress.id}');
    debugPrint('UPDATED ADDRESS LABEL: ${updatedAddress.label}');

    return updatedAddress;

  }

  // ============================================================
  // DELETE ADDRESS
  // ============================================================

  Future<bool> deleteAddress({
    required String token,
    required int addressId,
  }) async {
    if (addressId <= 0) {
      throw Exception('Invalid address ID.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}'
          '${ApiConstants.deleteAddress(addressId)}',
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('            DELETE ADDRESS                ');
    debugPrint('==========================================');
    debugPrint('METHOD: DELETE');
    debugPrint('ADDRESS ID: $addressId');
    debugPrint('URL: $uri');
    debugPrint('==========================================');

    final response = await http.delete(
      uri,
      headers: _headers(token),
    );

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('       DELETE ADDRESS RESPONSE            ');
    debugPrint('==========================================');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RESPONSE BODY:');
    debugPrint(response.body);
    debugPrint('==========================================');


    if (response.statusCode == 200) {
      if (response.body.trim().isEmpty) {
        await _clearAddressListCache(token);
        return true;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map &&
          decoded['success'] == true) {
        await _clearAddressListCache(token);
        return true;
      }

      if (decoded is Map &&
          decoded['message'] != null) {
        await _clearAddressListCache(token);
        return true;
      }

      throw Exception(
        decoded is Map
            ? decoded['message']?.toString() ??
            'Address deletion failed.'
            : 'Address deletion failed.',
      );
    }

    if (response.statusCode == 204) {
      await _clearAddressListCache(token);
      return true;
    }

    throw Exception(
      'Failed to delete address: '
          '${response.statusCode}\n'
          '${response.body}',
    );
  }

  // ============================================================
  // PARSE ADDRESS RESPONSE
  // ============================================================

  MilestoneApp6Address _parseAddressResponse(
      String responseBody,
      ) {
    final decoded = jsonDecode(responseBody);

    if (decoded is! Map) {
      throw Exception(
        'Invalid address response.',
      );
    }

    final rawData =
        decoded['data'] ?? decoded;

    if (rawData is! Map) {
      throw Exception(
        'Address data not found.',
      );
    }

    final address =
    MilestoneApp6Address.fromJson(
      Map<String, dynamic>.from(
        rawData,
      ),
    );

    if (address.id <= 0) {
      throw Exception(
        'Backend did not return a valid address ID.',
      );
    }

    return address;
  }
}