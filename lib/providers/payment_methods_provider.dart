import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/payment_methods_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'payment_methods_provider.g.dart';

@riverpod
class PaymentMethods extends _$PaymentMethods {

  @override
  AsyncState<PaymentGatewayData> build() {
    return const AsyncState();
  }

  Future<void> getPaymentMethods() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        ApiEndpoints.paymentMethodsList,
        requireAuth: true,
      );

      if (!ref.mounted) return;

      final response = PaymentGatewayResponse.fromJson(res.data as Map<String, dynamic>);

      state = state.copyWith(
        isLoading: false,
        data: response.data,
        error: null,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<RazorpayInitiateResponse?> razorPayment() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        '${ApiEndpoints.paymentRazorpay}/razorpay?currency=INR',
        requireAuth: true,
      );

      if (!ref.mounted) return null;

      final response = RazorpayInitiateResponse.fromJson(res.data as Map<String, dynamic>);

      state = state.copyWith(
        isLoading: false,
        error: null,
      );
      return response;
    } catch (e) {
      if (!ref.mounted) return null;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<bool> freeOrderPayment() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        ApiEndpoints.freeOrder,
        requireAuth: true,
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Free Order Placed Successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to upload profile picture: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }






}