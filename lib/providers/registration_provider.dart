import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/api_services.dart';
import '../models/registration_req_model.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'registration_provider.g.dart';

@riverpod
class Register extends _$Register {

  @override
  AsyncState<RegistrationModel> build() {
    return const AsyncState();
  }

  Future<void> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.post(
        ApiEndpoints.register,
        data: request.toJson(),
        requireAuth: false,
      );

      final model = RegistrationModel.fromJson(res.data!);

      if (model.status == 'error') {
        state = state.copyWith(
          isLoading: false,
          error: model.message ?? 'Registration failed',
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        data: model,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }


}
