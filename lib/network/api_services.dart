// lib/network/api_service.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbi_riverpod_project/views/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_navigator.dart';
import 'api_urls.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode}) ;

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = ApiEndpoints.baseUrl;

  // Static shared token across all instances — single source of truth
  static String? _authToken;

  // Hard limits for error messages
  static const int _maxErrorMessageLength = 300;
  static const int _maxLoggedBodyLength = 2000;

  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 90),
        receiveTimeout: const Duration(seconds: 90),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Allow 2xx and 4xx status codes so we can parse functional error messages from the body
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // DEV: Bypass SSL in debug mode (remove in production!)
    if (kDebugMode) {
      try {
        (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        };
      } catch (_) {}
    }

    // Logging interceptor only in debug, with truncation
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          logPrint: (obj) {
            final text = obj.toString();
            if (text.length > _maxLoggedBodyLength) {
              debugPrint(
                '${text.substring(0, _maxLoggedBodyLength)}\n--- LOG TRUNCATED ---',
              );
            } else {
              debugPrint(text);
            }
          },
        ),
      );
    }
  }

  static String url(String endpoint) => baseUrl + endpoint;

  // =========================
  // GET
  // =========================
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required bool requireAuth,
  }) async {
    try {
      final headers = await _buildHeaders(requireAuth);
      final response = await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // =========================
  // POST
  // =========================
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required bool requireAuth,
    String? contentType,
  }) async {
    try {
      final headers = await _buildHeaders(requireAuth, contentType: contentType);
      final response = await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // =========================
  // DELETE (ADDED)
  // =========================
  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required bool requireAuth,
  }) async {
    try {
      final headers = await _buildHeaders(requireAuth);

      final response = await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // =========================
  // PUT
  // =========================
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required bool requireAuth,
    String? contentType,
  }) async {
    try {
      final headers = await _buildHeaders(requireAuth, contentType: contentType);
      final response = await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // =========================
  // Headers
  // =========================
  Future<Map<String, dynamic>> _buildHeaders(bool requireAuth, {String? contentType}) async {
    final headers = <String, dynamic>{
      'Accept': 'application/json',
    };

    if (contentType != null) {
      headers['Content-Type'] = contentType;
    } else {
      headers['Content-Type'] = 'application/json';
    }

    if (requireAuth) {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// Save token + update static in-memory cache (USE THIS AFTER LOGIN)
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      _authToken = token;
      debugPrint('[ApiService] saveToken: token saved and cached in-memory');
    } catch (e) {
      debugPrint('saveToken error: $e');
    }
  }

  /// Clear token from both in-memory and persistent store
  static Future<void> clearToken() async {
    _authToken = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      debugPrint(
        '[ApiService] clearToken: token cleared from prefs and memory',
      );
    } catch (e) {
      debugPrint('[ApiService] clearToken error: $e');
    }
  }

  // Internal: Get token (returns cached in-memory token if present)
  static Future<String?> _getToken() async {
    if (_authToken != null && _authToken!.isNotEmpty) {
      return _authToken;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('auth_token');
    } catch (e) {
      debugPrint('[ApiService] _getToken error: $e');
      _authToken = null;
    }
    return _authToken;
  }

  // =========================
  // Response validation
  // =========================

  void _validateResponse<T>(Response<T> response) {
    final contentType = response.headers.value('content-type') ?? '';
    final data = response.data;

    if (data is String && _looksLikeHtml(data)) {
      throw ApiException(
        'Server returned an unexpected response. Please try again later.',
        statusCode: response.statusCode,
      );
    }

    if (contentType.contains('text/html')) {
      throw ApiException(
        'Server returned an unexpected response. Please try again later.',
        statusCode: response.statusCode,
      );
    }

    if (data is String && data.length > _maxLoggedBodyLength) {
      throw ApiException(
        'Received an unusually large response from server. Please try again.',
        statusCode: response.statusCode,
      );
    }
  }

  bool _looksLikeHtml(String s) {
    final lower = s.toLowerCase();
    return lower.contains('<html') ||
        lower.contains('<!doctype html') ||
        lower.contains('<head') ||
        lower.contains('<body');
  }

  // =========================
  // Navigation helper (robust)
  // =========================

  void _redirectToLogin(String snackBarMessage) {
    try {
      final navigator = AppNavigator.navigatorKey.currentState;
      if (navigator != null) {
        ScaffoldMessenger.of(
          navigator.context,
        ).showSnackBar(SnackBar(content: Text(snackBarMessage)));

        debugPrint('[ApiService] Redirecting to Login (navigator available).');
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final navRetry = AppNavigator.navigatorKey.currentState;
        if (navRetry != null) {
          ScaffoldMessenger.of(
            navRetry.context,
          ).showSnackBar(SnackBar(content: Text(snackBarMessage)));

          debugPrint(
            '[ApiService] Redirecting to Login (post-frame retry successful).',
          );
          navRetry.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } else {
          debugPrint(
            '[ApiService] Redirect to Login failed: navigator still null.',
          );
        }
      });
    } catch (e) {
      debugPrint('[ApiService] _redirectToLogin error: $e');
    }
  }

  // =========================
  // Error handler
  // =========================
  ApiException _handleError(DioException error) {
    final statusCode = error.response?.statusCode;
    String message;

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'No internet connection. Please check your network.';
      return ApiException(message, statusCode: statusCode);
    }

    if (error.type == DioExceptionType.badResponse && error.response != null) {
      final response = error.response!;

      if (statusCode == 419) {
        clearToken();
        const snackBarMessage = 'Session expired, please login.';
        _redirectToLogin(snackBarMessage);

        return ApiException(
          'Your session has expired. Please login again.',
          statusCode: statusCode,
        );
      }

      final backendMessage = _extractBackendMessage(response);

      if (backendMessage != null && backendMessage.isNotEmpty) {
        message = backendMessage;
      } else {
        message = _mapStatusCodeToMessage(statusCode);
      }

      return ApiException(message, statusCode: statusCode);
    }

    message = 'Something went wrong. Please try again.';
    return ApiException(message, statusCode: statusCode);
  }

  String? _extractBackendMessage(Response response) {
    final data = response.data;
    final contentType = response.headers.value('content-type') ?? '';

    if (contentType.contains('text/html')) {
      return null;
    }

    if (data is Map<String, dynamic>) {
      final candidate =
          data['message'] ??
          data['error'] ??
          data['detail'] ??
          data['error_message'];

      if (candidate is String && candidate.trim().isNotEmpty) {
        if (_looksLikeHtml(candidate)) return null;
        return _truncate(candidate);
      }

      if (candidate is Map) {
        final messages = <String>[];
        candidate.forEach((key, value) {
          if (value is List) {
            messages.add(value.join(', '));
          } else if (value is String) {
            messages.add(value);
          }
        });
        if (messages.isNotEmpty) {
          return _truncate(messages.join('\n'));
        }
      }

      return null;
    }

    if (data is String) {
      if (_looksLikeHtml(data)) return null;
      return _truncate(data);
    }

    return null;
  }

  String _mapStatusCodeToMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'You do not have permission for this action.';
      case 404:
        return 'Requested resource not found.';
      case 409:
        return 'There is a conflict with the current state. Please try again.';
      case 422:
        return 'Validation failed. Please check your input.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
      case 503:
      case 504:
        return 'Server is currently unavailable. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  String _truncate(String value) {
    if (value.length <= _maxErrorMessageLength) return value;
    return value.substring(0, _maxErrorMessageLength) + '...';
  }
}
