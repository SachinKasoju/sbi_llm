class CategoryResponse {
  final String status;
  final List<CategoryModel> data;

  CategoryResponse({
    required this.status,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CategoryModel.fromJson(
        item as Map<String, dynamic>,
      ))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class CategoryModel {
  final String slug;
  final String name;
  final String icon;
  final bool showAtTrending;

  CategoryModel({
    required this.slug,
    required this.name,
    required this.icon,
    required this.showAtTrending,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      showAtTrending: json['show_at_trending'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'icon': icon,
      'show_at_trending': showAtTrending,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          slug == other.slug;

  @override
  int get hashCode => slug.hashCode;
}