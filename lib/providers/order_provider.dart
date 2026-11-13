import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/orders_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'order_provider.g.dart';

class OrderState {
  final AsyncState<List<OrderModel>> ordersList;
  final AsyncState<InvoiceData> invoiceDetails;
  final int page;
  final bool hasMore;

  OrderState({
    this.ordersList = const AsyncState(),
    this.invoiceDetails = const AsyncState(),
    this.page = 1,
    this.hasMore = true,
  });

  OrderState copyWith({
    AsyncState<List<OrderModel>>? ordersList,
    AsyncState<InvoiceData>? invoiceDetails,
    int? page,
    bool? hasMore,
  }) {
    return OrderState(
      ordersList: ordersList ?? this.ordersList,
      invoiceDetails: invoiceDetails ?? this.invoiceDetails,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

@riverpod
class Order extends _$Order {
  @override
  OrderState build() {
    return OrderState();
  }

  Future<void> getOrders({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(
        page: 1,
        hasMore: true,
        ordersList: state.ordersList.copyWith(isLoading: true, error: null),
      );
    } else {
      if (!state.hasMore || state.ordersList.isLoading) return;
      state = state.copyWith(
        ordersList: state.ordersList.copyWith(isLoading: true, error: null),
      );
    }

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        ApiEndpoints.orders,
        queryParameters: {'page': state.page},
        requireAuth: true,
      );

      if (!ref.mounted) return;

      final response = OrdersResponse.fromJson(res.data as Map<String, dynamic>);

      final currentData = isRefresh ? <OrderModel>[] : (state.ordersList.data ?? []);
      final newData = [...currentData, ...response.data];

      state = state.copyWith(
        ordersList: AsyncState(
          isLoading: false,
          data: newData,
          error: null,
        ),
        page: response.pagination.currentPage + 1,
        hasMore: response.pagination.currentPage < response.pagination.lastPage,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        ordersList: state.ordersList.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> getOrderInvoice(String invoiceId) async {
    state = state.copyWith(
      invoiceDetails: state.invoiceDetails.copyWith(isLoading: true, error: null),
    );

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        '${ApiEndpoints.orders}/$invoiceId',
        requireAuth: true,
      );

      if (!ref.mounted) return;

      final response = InvoiceResponse.fromJson(res.data as Map<String, dynamic>);

      state = state.copyWith(
        invoiceDetails: AsyncState(
          isLoading: false,
          data: response.data,
          error: null,
        ),
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        invoiceDetails: state.invoiceDetails.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<bool> downloadInvoice(String invoiceId) async {
    // We don't necessarily need to change the main state for downloading, 
    // but we could if we wanted to show a global loader.
    // For now, let's just use toast for feedback.

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        '${ApiEndpoints.downloadInvoice}/$invoiceId',
        requireAuth: true,
      );

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Downloaded invoice successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
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
        msg: "Failed to download invoice: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
}
