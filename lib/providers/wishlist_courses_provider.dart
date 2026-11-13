import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/wishlist_courses_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'wishlist_courses_provider.g.dart';

@riverpod
class WishlistCourses extends _$WishlistCourses {
  int _page = 1;
  bool _hasMore = true;


  @override
  AsyncState<List<WishlistCourse>> build() {
    return const AsyncState();
  }

  Future<void> getWishlistCourses({bool isRefresh = false}) async {
    if (isRefresh) {
      _page = 1;
      _hasMore = true;
    }

    if (!_hasMore) return;

    if (state.isLoading && !isRefresh) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        ApiEndpoints.wishlistCourses,
        queryParameters: {'page': _page},
        requireAuth: true,
      );

      if (!ref.mounted) return;

      final response =  WishlistResponse.fromJson(res.data as Map<String, dynamic>);

      final currentData = isRefresh ? <WishlistCourse>[] : (state.data ?? []);
      final newData = [...currentData, ...response.data];

      if (response.pagination != null) {
        _page = response.pagination!.currentPage + 1;
        _hasMore = response.pagination!.currentPage < response.pagination!.lastPage;
      } else {
        _hasMore = false;
      }

      state = state.copyWith(
        isLoading: false,
        data: newData,
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

  Future<bool> addRemoveWishlist(String slug) async {
    // We don't necessarily need to change the main state for downloading,
    // but we could if we wanted to show a global loader.
    // For now, let's just use toast for feedback.

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        '${ApiEndpoints.addRemoveWishlist}/$slug',
        requireAuth: true,
      );



    final status = res.data['status'];
      final message = res.data['message'] ?? (status == 'success' ? 'Wishlist updated' : 'Operation failed');

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
        msg: "Failed to update wishlist: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }


}