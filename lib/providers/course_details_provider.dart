import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/course_details_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'course_details_provider.g.dart';

@Riverpod(keepAlive: true)
class CourseDetails extends _$CourseDetails {

  @override
  AsyncState<CourseDetailsModel> build() {
    return const AsyncState();
  }

  Future<void> getCourseDetails(String slug) async {
    // Clear previous data and set to loading state
    state = const AsyncState(isLoading: true);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        '${ApiEndpoints.courseDetails}/$slug',
        requireAuth: true,
      );

      // Check if the provider is still active before updating state
      if (!ref.mounted) return;

      final response = CourseDetailsResponse.fromJson(res.data as Map<String, dynamic>);

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
