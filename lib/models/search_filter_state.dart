import 'category_main_model.dart';
import 'sub_category_model.dart';
import 'course_language_model.dart';
import 'course_levels_model.dart';

class SearchFilterState {
  final String query;
  final CategoryModel? category;
  final SubcategoryModel? subCategory;
  final String pricing;
  final LanguageModel? language;
  final LevelModel? level;
  final int? rating;

  SearchFilterState({
    this.query = '',
    this.category,
    this.subCategory,
    this.pricing = 'All',
    this.language,
    this.level,
    this.rating,
  });

  SearchFilterState copyWith({
    String? query,
    CategoryModel? category,
    SubcategoryModel? subCategory,
    String? pricing,
    LanguageModel? language,
    LevelModel? level,
    int? rating,
  }) {
    return SearchFilterState(
      query: query ?? this.query,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      pricing: pricing ?? this.pricing,
      language: language ?? this.language,
      level: level ?? this.level,
      rating: rating ?? this.rating,
    );
  }

  SearchFilterState clear() {
    return SearchFilterState();
  }

  Map<String, dynamic> toQueryParameters() {
    return {
      'search': query,
      'main_category': category?.slug ?? '',
      'sub_category': subCategory?.slug ?? '',
      'languages': language?.name ?? '',
      'levels': level?.slug ?? '',
      'price': pricing.toLowerCase(),
      'rating': rating?.toString() ?? '',
    };
  }
}
