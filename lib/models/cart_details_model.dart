
class CartResponse {
  final String? status;
  final CartModel? data;

  CartResponse({
    this.status,
    this.data,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      status: json['status'] as String?,
      data: json['data'] != null
          ? CartModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class CartModel {
  final int? totalQty;
  final String? totalAmount;
  final List<CartCourseModel> cartCourses;

  CartModel({
    this.totalQty,
    this.totalAmount,
    this.cartCourses = const [],
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      totalQty: (json['total_qty'] as num?)?.toInt(),
      totalAmount: json['total_amount']?.toString(),
      cartCourses: (json['cart_courses'] as List<dynamic>?)
          ?.map(
            (item) => CartCourseModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_qty': totalQty,
      'total_amount': totalAmount,
      'cart_courses': cartCourses.map((e) => e.toJson()).toList(),
    };
  }
}

class CartCourseModel {
  final String? slug;
  final String? title;
  final String? thumbnail;
  final String? price;
  final double? discount;
  final CartInstructorModel? instructor;
  final int? students;
  final double? averageRating;

  CartCourseModel({
    this.slug,
    this.title,
    this.thumbnail,
    this.price,
    this.discount,
    this.instructor,
    this.students,
    this.averageRating,
  });

  factory CartCourseModel.fromJson(Map<String, dynamic> json) {
    return CartCourseModel(
      slug: json['slug'] as String?,
      title: json['title'] as String?,
      thumbnail: json['thumbnail'] as String?,
      price: json['price']?.toString(),
      discount: _toDouble(json['discount']),
      instructor: json['instructor'] != null
          ? CartInstructorModel.fromJson(
        Map<String, dynamic>.from(json['instructor'] as Map),
      )
          : null,
      students: (json['students'] as num?)?.toInt(),
      averageRating: _toDouble(json['average_rating']),
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

class CartInstructorModel {
  final int? id;
  final String? name;
  final String? image;

  CartInstructorModel({
    this.id,
    this.name,
    this.image,
  });

  factory CartInstructorModel.fromJson(Map<String, dynamic> json) {
    return CartInstructorModel(
      id: (json['id'] as num?)?.toInt(),
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

double? _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
