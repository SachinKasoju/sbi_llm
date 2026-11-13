class SearchCoursesModel {
  final String? status;
  final String? message;
  final List<CourseSearchModel>? data;
  final PaginationModel? pagination;

  SearchCoursesModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory SearchCoursesModel.fromJson(Map<String, dynamic> json) {
    return SearchCoursesModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CourseSearchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}





class CourseSearchModel {
  final String? slug;
  final String? title;
  final String? thumbnail;
  final double? price;
  final double? discount;
  final InstructorModel? instructor;
  final int? students;
  final double? averageRating;

  CourseSearchModel({
    this.slug,
    this.title,
    this.thumbnail,
    this.price,
    this.discount,
    this.instructor,
    this.students,
    this.averageRating,
  });

  // Safely convert int, double, or numeric String to double.
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      // Remove currency symbols, commas, and other formatting.
      final cleanedValue = value.replaceAll(
        RegExp(r'[^0-9.\-]'),
        '',
      );

      return double.tryParse(cleanedValue);
    }

    return null;
  }

  factory CourseSearchModel.fromJson(Map<String, dynamic> json) {
    return CourseSearchModel(
      slug: json['slug'] as String?,
      title: json['title'] as String?,
      thumbnail: json['thumbnail'] as String?,
      price: _parseDouble(json['price']),
      discount: _parseDouble(json['discount']),
      instructor: json['instructor'] != null
          ? InstructorModel.fromJson(
        json['instructor'] as Map<String, dynamic>,
      )
          : null,
      students: (json['students'] as num?)?.toInt(),
      averageRating: _parseDouble(json['average_rating']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'discount': discount,
      'instructor': instructor?.toJson(),
      'students': students,
      'average_rating': averageRating,
    };
  }
}

class InstructorModel {
  final int? id;
  final String? name;
  final String? image;

  InstructorModel({
    this.id,
    this.name,
    this.image,
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
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
      currentPage: json['current_page'] as int?,
      perPage: json['per_page'] as int?,
      total: json['total'] as int?,
      lastPage: json['last_page'] as int?,
      links: json['links'] != null
          ? PaginationLinksModel.fromJson(
        json['links'] as Map<String, dynamic>,
      )
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