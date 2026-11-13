import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sbi_riverpod_project/utils/async_notifier.dart';
import '../models/sub_category_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';

part 'sub_category_provider.g.dart';

@Riverpod(keepAlive: true)
class SubCategory extends _$SubCategory {
  @override
  AsyncState<List<SubcategoryModel>> build() {
    return const AsyncState<List<SubcategoryModel>>();
  }

  Future<bool> getSubCategories(String slug) async {
    state = const AsyncState<List<SubcategoryModel>>(
      isLoading: true,
    );

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        '${ApiEndpoints.subCategory}/$slug',
        requireAuth: false,
      );

      // Critical: check provider lifecycle after the async gap.
      if (!ref.mounted) return false;

      final dynamic rawData = res.data;
      final Map<String, dynamic> jsonMap;

      if (rawData is Map<String, dynamic>) {
        jsonMap = rawData;
      } else if (rawData is Map) {
        jsonMap = Map<String, dynamic>.from(rawData);
      } else if (rawData is String) {
        jsonMap = jsonDecode(rawData) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Unexpected response type: ${rawData.runtimeType}',
        );
      }

      final response = SubcategoryResponse.fromJson(jsonMap);



      state = AsyncState<List<SubcategoryModel>>(
        isLoading: false,
        data: response.data,
        error: null,
      );

      debugPrint(
        'Subcategories loaded: ${response.data.length}',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('Subcategory error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (ref.mounted) {
        state = AsyncState<List<SubcategoryModel>>(
          isLoading: false,
          error: e.toString(),
        );
      }

      return false;
    }
  }
}
