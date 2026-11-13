
class CourseDetailsResponse {
  final String? status;
  final CourseDetailsModel? data;

  CourseDetailsResponse({
    this.status,
    this.data,
  });

  factory CourseDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CourseDetailsResponse(
      status: json['status'] as String?,
      data: json['data'] != null
          ? CourseDetailsModel.fromJson(
        json['data'] as Map<String, dynamic>,
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

class CourseDetailsModel {
  final String? demoVideoSource;
  final String? demoVideo;
  final String? thumbnail;
  final bool? isWishlist;
  final String? title;
  final String? slug;
  final InstructorModel? instructor;
  final double? averageRating;
  final int? reviewsCount;
  final int? students;
  final String? lastUpdated;
  final String? duration;
  final bool? certificate;
  final int? lessonsCount;
  final int? quizzesCount;
  final String? languages;
  final String? price;
  final double? discount;
  final String? description;
  final List<CurriculumModel>? curriculums;

  CourseDetailsModel({
    this.demoVideoSource,
    this.demoVideo,
    this.thumbnail,
    this.isWishlist,
    this.title,
    this.slug,
    this.instructor,
    this.averageRating,
    this.reviewsCount,
    this.students,
    this.lastUpdated,
    this.duration,
    this.certificate,
    this.lessonsCount,
    this.quizzesCount,
    this.languages,
    this.price,
    this.discount,
    this.description,
    this.curriculums,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      demoVideoSource: json['demo_video_source'] as String?,
      demoVideo: json['demo_video'] as String?,
      thumbnail: json['thumbnail'] as String?,
      isWishlist: json['is_wishlist'] as bool?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      instructor: json['instructor'] != null
          ? InstructorModel.fromJson(
        json['instructor'] as Map<String, dynamic>,
      )
          : null,
      averageRating: _toDouble(json['average_rating']),
      reviewsCount: _toInt(json['reviews_count']),
      students: _toInt(json['students']),
      lastUpdated: json['last_updated'] as String?,
      duration: json['duration'] as String?,
      certificate: json['certificate'] as bool?,
      lessonsCount: _toInt(json['lessons_count']),
      quizzesCount: _toInt(json['quizzes_count']),
      languages: json['languages'] as String?,
      price: json['price']?.toString(),
      discount: _toDouble(json['discount']),
      description: json['description'] as String?,
      curriculums: (json['curriculums'] as List<dynamic>?)
          ?.map(
            (e) => CurriculumModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'demo_video_source': demoVideoSource,
      'demo_video': demoVideo,
      'thumbnail': thumbnail,
      'is_wishlist': isWishlist,
      'title': title,
      'slug': slug,
      'instructor': instructor?.toJson(),
      'average_rating': averageRating,
      'reviews_count': reviewsCount,
      'students': students,
      'last_updated': lastUpdated,
      'duration': duration,
      'certificate': certificate,
      'lessons_count': lessonsCount,
      'quizzes_count': quizzesCount,
      'languages': languages,
      'price': price,
      'discount': discount,
      'description': description,
      'curriculums': curriculums
          ?.map((e) => e.toJson())
          .toList(),
    };
  }
}

double? _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _toInt(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
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
      id: _toInt(json['id']),
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

class CurriculumModel {
  final int? id;
  final String? title;
  final List<ChapterModel>? chapters;

  CurriculumModel({
    this.id,
    this.title,
    this.chapters,
  });

  factory CurriculumModel.fromJson(Map<String, dynamic> json) {
    return CurriculumModel(
      id: _toInt(json['id']),
      title: json['title'] as String?,
      chapters: (json['chapters'] as List<dynamic>?)
          ?.map(
            (e) => ChapterModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'chapters': chapters
          ?.map((e) => e.toJson())
          .toList(),
    };
  }
}

class ChapterModel {
  final String? type;
  final ChapterItemModel? item;

  ChapterModel({
    this.type,
    this.item,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      type: json['type'] as String?,
      item: json['item'] != null
          ? ChapterItemModel.fromJson(
        json['item'] as Map<String, dynamic>,
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'item': item?.toJson(),
    };
  }
}

class ChapterItemModel {
  final int? id;
  final String? title;
  final String? fileType;
  final String? duration;
  final bool? isFree;

  ChapterItemModel({
    this.id,
    this.title,
    this.fileType,
    this.duration,
    this.isFree,
  });

  factory ChapterItemModel.fromJson(Map<String, dynamic> json) {
    return ChapterItemModel(
      id: _toInt(json['id']),
      title: json['title'] as String?,
      fileType: json['file_type'] as String?,
      duration: json['duration'] as String?,
      isFree: json['is_free'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file_type': fileType,
      'duration': duration,
      'is_free': isFree,
    };
  }
}
