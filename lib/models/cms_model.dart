class CmsResponse {
  final String status;
  final CmsModel data;

  CmsResponse({
    required this.status,
    required this.data,
  });

  factory CmsResponse.fromJson(Map<String, dynamic> json) {
    return CmsResponse(
      status: json['status'] ?? '',
      data: CmsModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class CmsModel {
  final String slug;
  final String name;
  final String content;

  CmsModel({
    required this.slug,
    required this.name,
    required this.content,
  });

  factory CmsModel.fromJson(Map<String, dynamic> json) {
    return CmsModel(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'content': content,
    };
  }
}
