import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/course_language_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'course_language_provider.g.dart';

@riverpod
class CourseLanguage extends _$CourseLanguage {
  @override
  AsyncState<List<LanguageModel>> build() {
    return const AsyncState();
  }

  Future<void> courseLanguages() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        ApiEndpoints.courseLanguage,
        requireAuth: false,
      );

      if (!ref.mounted) return;

      final response = LanguageResponse.fromJson(res.data as Map<String, dynamic>);

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