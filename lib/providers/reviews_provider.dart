import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/reviews_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'reviews_provider.g.dart';

@riverpod
class Reviews extends _$Reviews {
  @override
  AsyncState<CourseReviewsResponseModel> build() {
    return const AsyncState();
  }

  Future<void> getReviews(String course, {int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (state.data?.pagination?.currentPage == state.data?.pagination?.lastPage) return;
      state = state.copyWith(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        '${ApiEndpoints.reviews}/$course',
        queryParameters: {'page': page},
        requireAuth: false,
      );

      if (!ref.mounted) return;

      final response = CourseReviewsResponseModel.fromJson(res.data as Map<String, dynamic>);

      if (isLoadMore) {
        final List<CourseReviewModel> currentData = state.data?.data ?? <CourseReviewModel>[];
        final List<CourseReviewModel> newData = [...currentData, ...(response.data ?? <CourseReviewModel>[])];
        state = state.copyWith(
          isLoading: false,
          data: CourseReviewsResponseModel(
            status: response.status,
            data: newData,
            pagination: response.pagination,
          ),
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          data: response,
          error: null,
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}