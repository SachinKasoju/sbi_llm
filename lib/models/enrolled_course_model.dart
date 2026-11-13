
class EnrolledCoursesResponse {
  final String status;
  final List<EnrolledCourseModel> data;
  final EnrolledCoursesPagination pagination;

  EnrolledCoursesResponse({
    required this.status,
    required this.data,
    required this.pagination,
  });

  factory EnrolledCoursesResponse.fromJson(
      Map<String, dynamic> json) {
    return EnrolledCoursesResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => EnrolledCourseModel.fromJson(
          e as Map<String, dynamic>))
          .toList() ??
          [],
      pagination: EnrolledCoursesPagination.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class EnrolledCourseModel {
  final String slug;
  final String title;
  final String thumbnail;
  final CourseInstructor instructor;
  final int students;
  final int progress;

  EnrolledCourseModel({
    required this.slug,
    required this.title,
    required this.thumbnail,
    required this.instructor,
    required this.students,
    required this.progress,
  });

  factory EnrolledCourseModel.fromJson(
      Map<String, dynamic> json) {
    return EnrolledCourseModel(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      instructor: CourseInstructor.fromJson(
        json['instructor'] as Map<String, dynamic>? ?? {},
      ),
      students: json['students'] ?? 0,
      progress: json['progress'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'title': title,
      'thumbnail': thumbnail,
      'instructor': instructor.toJson(),
      'students': students,
      'progress': progress,
    };
  }
}

class CourseInstructor {
  final int id;
  final String name;
  final String image;

  CourseInstructor({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CourseInstructor.fromJson(
      Map<String, dynamic> json) {
    return CourseInstructor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
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

class EnrolledCoursesPagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final EnrolledCoursesPaginationLinks links;

  EnrolledCoursesPagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.links,
  });

  factory EnrolledCoursesPagination.fromJson(
      Map<String, dynamic> json) {
    return EnrolledCoursesPagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      links: EnrolledCoursesPaginationLinks.fromJson(
        json['links'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'links': links.toJson(),
    };
  }
}

class EnrolledCoursesPaginationLinks {
  final String? first;
  final String? prev;
  final String? next;
  final String? last;

  EnrolledCoursesPaginationLinks({
    this.first,
    this.prev,
    this.next,
    this.last,
  });

  factory EnrolledCoursesPaginationLinks.fromJson(
      Map<String, dynamic> json) {
    return EnrolledCoursesPaginationLinks(
      first: json['first'],
      prev: json['prev'],
      next: json['next'],
      last: json['last'],
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
