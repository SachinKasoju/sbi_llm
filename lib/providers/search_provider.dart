import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/search_filter_state.dart';
import '../models/search_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'search_provider.g.dart';

@Riverpod(keepAlive: true)
class Search extends _$Search {
  @override
  AsyncState<List<CourseSearchModel>> build() {
    return const AsyncState();
  }

  Future<void> searchCourses(SearchFilterState request) async {
    // Safety check: Don't proceed if provider was disposed
    if (!ref.mounted) return;
    
    // Clear error and set loading state. We keep data during loading for smoother transitions 
    // if the UI supports it, but SearchResultPage currently shows a loader.
    state = AsyncState(isLoading: true, data: state.data);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        ApiEndpoints.searchCourses,
        queryParameters: request.toQueryParameters(),
        requireAuth: false,
      );

      // Safety check after async gap
      if (!ref.mounted) return;

      final model = SearchCoursesModel.fromJson(res.data as Map<String, dynamic>);

      if (model.status == 'error') {
        // Safety check before updating state
        if (!ref.mounted) return;
        state = state.copyWith(
          isLoading: false,
          error: model.message ?? 'Search failed',
        );
        return;
      }

      // Safety check before updating state
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        data: model.data,
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
