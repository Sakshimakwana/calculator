import 'dart:convert';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/modelss/milestone_app_6_address_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';

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

    final response = await http.get(
      uri,
      headers: _headers(token),
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

    return _parseAddressResponse(
      response.body,
    );
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
        return true;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map &&
          decoded['success'] == true) {
        return true;
      }

      if (decoded is Map &&
          decoded['message'] != null) {
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