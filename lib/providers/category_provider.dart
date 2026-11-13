import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sbi_riverpod_project/utils/async_notifier.dart';
import '../network/api_services.dart';
import '../models/category_main_model.dart';
import '../network/api_urls.dart';


part 'category_provider.g.dart';

@riverpod
class Category extends _$Category{

  @override
  AsyncState<List<CategoryModel>> build() {
    return const AsyncState();
  }

  Future<void> mainCategory() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        ApiEndpoints.category,
        requireAuth: false,
      );

      if (!ref.mounted) return;

      final response = CategoryResponse.fromJson(res.data as Map<String, dynamic>);

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

}