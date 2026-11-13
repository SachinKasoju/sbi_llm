// lib/providers/core/login_provider.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_req_model.dart';
import '../models/login_res_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'auth_provider.g.dart';

@riverpod
class Login extends _$Login {
  // Constants for SharedPreferences keys
  static const String _prefEmailKey = 'userEmail';
  static const String _prefPasswordKey = 'userPassword';

  @override
  AsyncState<LoginResModel> build() {
    return const AsyncState();
  }

  /// Helper function to save email and password locally
  static Future<void> _saveCredentials(
      String email,
      String password,
      String phone,
      bool isAiMailEnabled,
      int aiAnalysisLimit,
      int currentSubscriptionId,
      String currentBureaus,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefEmailKey, email);
    await prefs.setString(_prefPasswordKey, password);
    await prefs.setString('phone_number', phone);
    await prefs.setBool('is_ai_mail_enabled', isAiMailEnabled);
    await prefs.setInt('ai_analysis_limit', aiAnalysisLimit);
    await prefs.setInt('currentSubscriptionId', currentSubscriptionId);
    await prefs.setString('current_bureaus', currentBureaus);
    debugPrint('Credentials saved to SharedPreferences.');
  }

  /// Performs login, saves token and credentials, and updates state
  Future<void> login({required String email, required String password}) async {
    state = const AsyncState(isLoading: true);

    try {
      final api = ref.read(apiServiceProvider);
      final request = LoginRequest(email: email, password: password);

      final response = await api.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: request.toJson(),
        requireAuth: false,
      );

      if (!ref.mounted) return;

      if (response.data == null) {
        throw ApiException('Empty response from server');
      }

      // Parse the full response into LoginResModel+

      final loginResponse = LoginResModel.fromJson(response.data!);

      if (loginResponse.status == 'error') {
        state = state.copyWith(
          isLoading: false,
          error: loginResponse.message ?? 'Login failed',
        );
        return;
      }

      // Extract token safely from the model
      final String? token = loginResponse.bearerToken ?? loginResponse.data?.user?.token;
      final String? phone = loginResponse.data?.user?.phone;
      final bool isAiMailEnabled = loginResponse.data?.aiMailDrafting ?? false;
      final int aiAnalysisLimit = loginResponse.data?.aiAnalysisLimit ?? 0;
      final int currentSubscriptionId = loginResponse.data?.subscriptionStatus ?? 0;
      final String currentBureaus = loginResponse.data?.subscriptionBureaus ?? '';

      if (token != null && token.isNotEmpty) {
        await ApiService.saveToken(token);
        await _saveCredentials(
          email,
          password,
          phone ?? '',
          isAiMailEnabled,
          aiAnalysisLimit,
          currentSubscriptionId,
          currentBureaus,
        );

        debugPrint('Token and Credentials saved successfully.');
      } else {
        debugPrint('[LoginProvider] Token not found in response!');
      }

      if (!ref.mounted) return;

      // Update state with success
      state = state.copyWith(
        isLoading: false,
        data: loginResponse,
        error: null,
      );
    } on ApiException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, stackTrace) {
      debugPrint('[LoginProvider] Unexpected error: $e');
      debugPrint(stackTrace.toString());
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed. Please try again.',
      );
    }
  }

  Future<void> forgotPassword({required String email}) async {
    state = const AsyncState(isLoading: true);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.post<Map<String, dynamic>>(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
        requireAuth: false,
      );

      if (!ref.mounted) return;

      if (res.data == null) {
        throw ApiException('Empty response from server');
      }

      final responseModel = LoginResModel.fromJson(res.data!);

      state = state.copyWith(
        isLoading: false,
        data: responseModel,
        error: null,
      );
    } on ApiException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to send reset link. Please try again.',
      );
    }
  }

  /// Helper function to clear credentials
  static Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefEmailKey);
    await prefs.remove(_prefPasswordKey);
    await prefs.remove('phone_number');
    await prefs.remove('is_ai_mail_enabled');
    await prefs.remove('ai_analysis_limit');
    await prefs.remove('currentSubscriptionId');
    await prefs.remove('current_bureaus');
    await ApiService.clearToken();
    debugPrint('Credentials cleared from SharedPreferences.');
  }

  Future<void> logout() async {
    state = const AsyncState(isLoading: true);

    try {
      final api = ref.read(apiServiceProvider);

      // Attempt API logout - using requireAuth: true to send the token
      await api.post<Map<String, dynamic>>(
        ApiEndpoints.logout,
        requireAuth: true,
      );

      await _clearCredentials();

      if (!ref.mounted) return;
      state = const AsyncState(data: null);
    } on ApiException catch (e) {
      debugPrint('[LoginProvider] API logout error: ${e.message}');
      // Even if API fails, we should clear local data
      await _clearCredentials();
      if (!ref.mounted) return;
      state = const AsyncState(data: null);
    } catch (e) {
      debugPrint('[LoginProvider] Unexpected logout error: $e');
      await _clearCredentials();
      if (!ref.mounted) return;
      state = const AsyncState(data: null);
    }
  }
}
