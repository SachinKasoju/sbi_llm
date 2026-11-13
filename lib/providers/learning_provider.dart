
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/learning_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'learning_provider.g.dart';

@riverpod
class Learning extends _$Learning{
  @override
  AsyncState<CourseDetail> build() {
    return const AsyncState();
  }

  Future<void> getLearning(String slug) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        '${ApiEndpoints.learning}/$slug',
        requireAuth: true,
      );

      if (!ref.mounted) return;

      final response = CourseDetailResponse.fromJson(res.data as Map<String, dynamic>);

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