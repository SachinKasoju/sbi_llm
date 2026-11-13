import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/search_filter_state.dart';
import '../models/category_main_model.dart';
import '../models/sub_category_model.dart';
import '../models/course_language_model.dart';
import '../models/course_levels_model.dart';

part 'search_filter_provider.g.dart';

@riverpod
class SearchFilter extends _$SearchFilter {
  @override
  SearchFilterState build() {
    return SearchFilterState();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setCategory(CategoryModel? category) {
    state = state.copyWith(category: category, subCategory: null);
  }

  void setSubCategory(SubcategoryModel? subCategory) {
    state = state.copyWith(subCategory: subCategory);
  }

  void setPricing(String pricing) {
    state = state.copyWith(pricing: pricing);
  }

  void setLanguage(LanguageModel? language) {
    state = state.copyWith(language: language);
  }

  void setLevel(LevelModel? level) {
    state = state.copyWith(level: level);
  }

  void setRating(int? rating) {
    state = state.copyWith(rating: rating);
  }

  void clear() {
    state = state.clear();
  }
}
