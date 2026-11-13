class LevelResponse {
  final String status;
  final List<LevelModel> data;

  LevelResponse({
    required this.status,
    required this.data,
  });

  factory LevelResponse.fromJson(Map<String, dynamic> json) {
    return LevelResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => LevelModel.fromJson(
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

class LevelModel {
  final String slug;
  final String name;

  LevelModel({
    required this.slug,
    required this.name,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
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
      other is LevelModel &&
          runtimeType == other.runtimeType &&
          slug == other.slug;

  @override
  int get hashCode => slug.hashCode;
}