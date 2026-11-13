import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/course_levels_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'course_levels_provider.g.dart';

@riverpod
class CourseLevels extends _$CourseLevels {
@override
AsyncState<List<LevelModel>> build() {
  return const AsyncState();
}

Future<void> courseLevels() async {
  state = state.copyWith(isLoading: true, error: null);

  try {
    final api = ref.read(apiServiceProvider);

    final res = await api.get(
      ApiEndpoints.courseLevels,
      requireAuth: false,
    );

    if (!ref.mounted) return;

    final response = LevelResponse.fromJson(res.data as Map<String, dynamic>);

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