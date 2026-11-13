import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/enrolled_course_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'enrolled_course_provider.g.dart';

@riverpod
class EnrolledCourse extends _$EnrolledCourse {
  int _page = 1;
  bool _hasMore = true;

  @override
  AsyncState<List<EnrolledCourseModel>> build() {
    return const AsyncState();
  }

  Future<void> getEnrolledCourses({bool isRefresh = false}) async {
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
        ApiEndpoints.enrolledCourses,
        queryParameters: {'page': _page},
        requireAuth: true,
      );

      if (!ref.mounted) return;

      final response =
          EnrolledCoursesResponse.fromJson(res.data as Map<String, dynamic>);

      final currentData = isRefresh ? <EnrolledCourseModel>[] : (state.data ?? []);
      final newData = [...currentData, ...response.data];

      _page = response.pagination.currentPage + 1;
      _hasMore = response.pagination.currentPage < response.pagination.lastPage;

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
}
