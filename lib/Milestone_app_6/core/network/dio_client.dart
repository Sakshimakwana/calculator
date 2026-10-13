
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/auth_storage/auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';

class DioClient {
  DioClient._();

  static const String _cachePrefix = 'api_cache_';
  static const Duration _cacheDuration = Duration(minutes: 5);

  static final Dio dio = _createDio();

  static Dio _createDio() {
    final client = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Always attach the current authentication token.
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthStorage.token;

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            options.headers.remove('Authorization');
          }

          handler.next(options);
        },
      ),
    );

    // Persistent GET cache.
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!_canCache(options)) {
            handler.next(options);
            return;
          }

          try {
            final cached = await _readCache(options);

            if (cached != null) {
              final savedAt = cached['savedAt'] as int;
              final age =
                  DateTime.now().millisecondsSinceEpoch - savedAt;

              if (age >= 0 &&
                  age < _cacheDuration.inMilliseconds) {
                options.extra['persistentCacheHit'] = true;

                handler.resolve(
                  Response<dynamic>(
                    requestOptions: options,
                    data: cached['data'],
                    statusCode: cached['statusCode'] as int? ?? 200,
                    extra: {'fromCache': true},
                  ),
                );
                return;
              }
            }
          } catch (_) {
            // A cache read failure must not block the API request.
          }

          handler.next(options);
        },
        onResponse: (response, handler) async {
          final options = response.requestOptions;

          if (_canCache(options) &&
              options.extra['persistentCacheHit'] != true &&
              response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            try {
              await _saveCache(response);
            } catch (_) {
              // A cache write failure must not break a successful API call.
            }
          }

          handler.next(response);
        },
        onError: (error, handler) async {
          final options = error.requestOptions;

          if (_canCache(options)) {
            try {
              final cached = await _readCache(options);

              // On network failure, permit stale data for up to 24 hours.
              if (cached != null) {
                final savedAt = cached['savedAt'] as int;
                final age =
                    DateTime.now().millisecondsSinceEpoch - savedAt;

                if (age >= 0 &&
                    age < const Duration(hours: 24).inMilliseconds) {
                  handler.resolve(
                    Response<dynamic>(
                      requestOptions: options,
                      data: cached['data'],
                      statusCode: cached['statusCode'] as int? ?? 200,
                      extra: {'fromCache': true, 'stale': true},
                    ),
                  );
                  return;
                }
              }
            } catch (_) {
              // Preserve the original network error.
            }
          }

          handler.next(error);
        },
      ),
    );

    return client;
  }

  // Only cache GET requests that are safe to reuse.
  static bool _canCache(RequestOptions options) {
    if (options.method.toUpperCase() != 'GET') return false;
    if (options.extra['skipCache'] == true) return false;

    final path = options.uri.path.toLowerCase();

    // These endpoints can contain rapidly changing or personal data.
    const excludedPaths = [
      '/cart',
      '/orders',
      '/payment',
      '/payments',
      '/delivery',
      '/deliveries',
      '/profile',
      '/addresses',
      '/reviews',
      '/login',
      '/logout',
      '/register',
    ];

    if (excludedPaths.any((part) => path.contains(part))) {
      return false;
    }

    return true;
  }

  static Future<String> _cacheKey(RequestOptions options) async {
    final prefs = await SharedPreferences.getInstance();
    final token = AuthStorage.token ?? 'public';

    // Hash both session and URL, including query parameters.
    final input = '$token|${options.uri}';
    final hash = sha256.convert(utf8.encode(input)).toString();

    return '$_cachePrefix$hash';
  }

  static Future<Map<String, dynamic>?> _readCache(
      RequestOptions options,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _cacheKey(options);
    final raw = prefs.getString(key);

    if (raw == null) return null;

    final decoded = jsonDecode(raw);

    if (decoded is! Map<String, dynamic>) return null;

    return decoded;
  }

  static Future<void> _saveCache(Response<dynamic> response) async {
    // This implementation caches JSON-compatible response bodies.
    final encodedData = jsonEncode(response.data);
    final options = response.requestOptions;
    final key = await _cacheKey(options);
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      key,
      jsonEncode({
        'savedAt': DateTime.now().millisecondsSinceEpoch,
        'statusCode': response.statusCode ?? 200,
        'data': jsonDecode(encodedData),
      }),
    );
  }

  // Use for requests that must always fetch fresh data.
  static Options get noCacheOptions => Options(
    extra: {'skipCache': true},
  );

  // Clear all cached API responses, such as on logout.
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();

    for (final key in prefs.getKeys().toList()) {
      if (key.startsWith(_cachePrefix)) {
        await prefs.remove(key);
      }
    }
  }
}
