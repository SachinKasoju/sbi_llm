class SubcategoryResponse {
  final String status;
  final List<SubcategoryModel> data;

  SubcategoryResponse({
    required this.status,
    required this.data,
  });

  factory SubcategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubcategoryResponse(
      status: json['status']?.toString() ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => SubcategoryModel.fromJson(
        Map<String, dynamic>.from(item as Map),
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


class SubcategoryModel {
  final String slug;
  final String name;

  SubcategoryModel({
    required this.slug,
    required this.name,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubcategoryModel &&
          runtimeType == other.runtimeType &&
          slug == other.slug;

  @override
  int get hashCode => slug.hashCode;
}