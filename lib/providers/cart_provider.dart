import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/cart_details_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  AsyncState<CartModel> build() {
    // Automatically fetch cart data when the provider is first accessed
    Future.microtask(() => getCart());
    return const AsyncState(isLoading: true);
  }

  /// Fetches the current cart items and totals from the API
  Future<void> getCart() async {
    state = state.copyWith(isLoading: true);

    try {
      final api = ref.read(apiServiceProvider);
      final res = await api.get(
        ApiEndpoints.cart,
        requireAuth: true,
      );

      if (!ref.mounted) return;

      final response = CartResponse.fromJson(res.data as Map<String, dynamic>);

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

  /// Adds a course to the cart using its slug
  Future<bool> addToCart(String slug) async {
    try {
      final api = ref.read(apiServiceProvider);
      
      // POST request as per the user's working snippet
      final res = await api.post(
        '${ApiEndpoints.addToCart}/$slug',
        requireAuth: true,
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Added to cart successfully!';
      final cartCountStr = res.data['cart_count']?.toString() ?? '0';
      final cartCount = int.tryParse(cartCountStr) ?? 0;

      if (status == 'success') {
        // Show success snackbar/toast
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );

        // Update local state with the new cart count to reflect in the UI immediately
        if (state.data != null) {
          state = state.copyWith(
            data: CartModel(
              totalQty: cartCount,
              totalAmount: state.data!.totalAmount,
              cartCourses: state.data!.cartCourses,
            ),
          );
        } else {
          // If no data was loaded yet, fetch the full cart structure
          await getCart();
        }
        return true;
      } else {
        // Show error message from backend if status is not success
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to add to cart: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> removeCart(String slug) async {
    try {
      final api = ref.read(apiServiceProvider);

      // Using the user's removeCart implementation but calling getCart() on success
      // to ensure all totals (amount, courses list) are correctly updated.
      final res = await api.delete(
        '${ApiEndpoints.removeCart}/$slug',
        requireAuth: true,
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Removed from cart successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );

        // Refresh the whole cart to get updated totals and list
        await getCart();
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
        msg: "Failed to remove from cart: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }


}
