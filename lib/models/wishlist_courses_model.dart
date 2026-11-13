class WishlistResponse {
  final String status;
  final List<WishlistCourse> data;
  final WishlistPagination? pagination;

  WishlistResponse({
    required this.status,
    required this.data,
    this.pagination,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => WishlistCourse.fromJson(e))
          .toList(),
      pagination: json['pagination'] != null
          ? WishlistPagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.map((e) => e.toJson()).toList(),
    'pagination': pagination?.toJson(),
  };
}

class WishlistCourse {
  final String slug;
  final String title;
  final String thumbnail;
  final dynamic price;
  final num discount;
  final WishlistInstructor? instructor;
  final int students;
  final num averageRating;

  WishlistCourse({
    required this.slug,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discount,
    this.instructor,
    required this.students,
    required this.averageRating,
  });

  factory WishlistCourse.fromJson(Map<String, dynamic> json) {
    return WishlistCourse(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      price: json['price'],
      discount: json['discount'] ?? 0,
      instructor: json['instructor'] != null
          ? WishlistInstructor.fromJson(json['instructor'])
          : null,
      students: json['students'] ?? 0,
      averageRating: json['average_rating'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
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

class WishlistInstructor {
  final int id;
  final String name;
  final String image;

  WishlistInstructor({
    required this.id,
    required this.name,
    required this.image,
  });

  factory WishlistInstructor.fromJson(Map<String, dynamic> json) {
    return WishlistInstructor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
  };
}

class WishlistPagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final WishlistPaginationLinks? links;

  WishlistPagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    this.links,
  });

  factory WishlistPagination.fromJson(Map<String, dynamic> json) {
    return WishlistPagination(
      currentPage: json['current_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      links: json['links'] != null
          ? WishlistPaginationLinks.fromJson(json['links'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'per_page': perPage,
    'total': total,
    'last_page': lastPage,
    'links': links?.toJson(),
  };
}

class WishlistPaginationLinks {
  final String? first;
  final String? prev;
  final String? next;
  final String? last;

  WishlistPaginationLinks({
    this.first,
    this.prev,
    this.next,
    this.last,
  });

  factory WishlistPaginationLinks.fromJson(Map<String, dynamic> json) {
    return WishlistPaginationLinks(
      first: json['first'],
      prev: json['prev'],
      next: json['next'],
      last: json['last'],
    );
  }

  Map<String, dynamic> toJson() => {
    'first': first,
    'prev': prev,
    'next': next,
    'last': last,
  };
}
