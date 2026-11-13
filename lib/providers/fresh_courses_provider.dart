import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/popular_courses_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'fresh_courses_provider.g.dart';

@riverpod
class FreshCourses extends _$FreshCourses {
  @override
  AsyncState<List<CourseModel>> build() {
    return const AsyncState();
  }

  Future<void> getFreshCourses() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        ApiEndpoints.freshCourses,
        requireAuth: false,
      );

      if (!ref.mounted) return;

      final response = CourseResponse.fromJson(res.data as Map<String, dynamic>);

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
