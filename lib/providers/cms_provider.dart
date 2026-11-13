import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/cms_model.dart';
import '../models/faqs_model.dart';
import '../models/settings_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';

part 'cms_provider.g.dart';

@riverpod
Future<CmsModel> privacyPolicy(Ref ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get(
    ApiEndpoints.privacyPolicy,
    requireAuth: false,
  );
  return CmsResponse.fromJson(res.data as Map<String, dynamic>).data;
}

@riverpod
Future<CmsModel> termsAndConditions(Ref ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get(
    ApiEndpoints.termsAndConditions,
    requireAuth: false,
  );
  return CmsResponse.fromJson(res.data as Map<String, dynamic>).data;
}

@riverpod
Future<List<FaqModel>> faqs(Ref ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get(
    ApiEndpoints.faqs,
    requireAuth: false,
  );
  return FaqResponse.fromJson(res.data as Map<String, dynamic>).data;
}

@riverpod
Future<AppConfigData?> settings(Ref ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get(
    ApiEndpoints.settings,
    requireAuth: false,
  );
  return AppConfigResponse.fromJson(res.data as Map<String, dynamic>).data;
}