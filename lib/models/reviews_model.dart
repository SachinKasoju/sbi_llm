class CourseReviewsResponseModel {
  final String? status;
  final List<CourseReviewModel>? data;
  final PaginationModel? pagination;

  CourseReviewsResponseModel({
    this.status,
    this.data,
    this.pagination,
  });

  factory CourseReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    return CourseReviewsResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List?)
          ?.map<CourseReviewModel>((e) => CourseReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class CourseReviewModel {
  final int? rating;
  final String? review;
  final String? name;
  final String? avatar;

  CourseReviewModel({
    this.rating,
    this.review,
    this.name,
    this.avatar,
  });

  factory CourseReviewModel.fromJson(Map<String, dynamic> json) {
    return CourseReviewModel(
      rating: _toInt(json['rating']),
      review: json['review'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'review': review,
      'name': name,
      'avatar': avatar,
    };
  }
}

class PaginationModel {
  final int? currentPage;
  final int? perPage;
  final int? total;
  final int? lastPage;
  final PaginationLinksModel? links;

  PaginationModel({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
    this.links,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: _toInt(json['current_page']),
      perPage: _toInt(json['per_page']),
      total: _toInt(json['total']),
      lastPage: _toInt(json['last_page']),
      links: json['links'] != null
          ? PaginationLinksModel.fromJson(json['links'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'links': links?.toJson(),
    };
  }
}

class PaginationLinksModel {
  final String? first;
  final String? prev;
  final String? next;
  final String? last;

  PaginationLinksModel({
    this.first,
    this.prev,
    this.next,
    this.last,
  });

  factory PaginationLinksModel.fromJson(Map<String, dynamic> json) {
    return PaginationLinksModel(
      first: json['first'] as String?,
      prev: json['prev'] as String?,
      next: json['next'] as String?,
      last: json['last'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'prev': prev,
      'next': next,
      'last': last,
    };
  }
}

int? _toInt(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
