
class CourseDetailResponse {
  final String status;
  final CourseDetail? data;

  CourseDetailResponse({
    required this.status,
    this.data,
  });

  factory CourseDetailResponse.fromJson(Map<String, dynamic> json) {
    return CourseDetailResponse(
      status: json['status'] ?? '',
      data: json['data'] != null
          ? CourseDetail.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.toJson(),
  };
}

class CourseDetail {
  final String thumbnail;
  final String title;
  final String description;
  final Instructor? instructor;
  final List<Curriculum> curriculums;
  final CurrentProgress? currentProgress;
  final List<dynamic> alreadyWatchedLectures;
  final List<dynamic> alreadyCompletedQuiz;

  CourseDetail({
    required this.thumbnail,
    required this.title,
    required this.description,
    this.instructor,
    required this.curriculums,
    this.currentProgress,
    required this.alreadyWatchedLectures,
    required this.alreadyCompletedQuiz,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] != null
          ? Instructor.fromJson(json['instructor'])
          : null,
      curriculums: (json['curriculums'] as List? ?? [])
          .map((e) => Curriculum.fromJson(e))
          .toList(),
      currentProgress: json['current_progress'] != null
          ? CurrentProgress.fromJson(json['current_progress'])
          : null,
      alreadyWatchedLectures:
      json['already_watched_lectures'] ?? [],
      alreadyCompletedQuiz:
      json['already_completed_quiz'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'thumbnail': thumbnail,
    'title': title,
    'description': description,
    'instructor': instructor?.toJson(),
    'curriculums': curriculums.map((e) => e.toJson()).toList(),
    'current_progress': currentProgress?.toJson(),
    'already_watched_lectures': alreadyWatchedLectures,
    'already_completed_quiz': alreadyCompletedQuiz,
  };
}

class Instructor {
  final int id;
  final String name;
  final String image;

  Instructor({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
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

class Curriculum {
  final int id;
  final String title;
  final List<Chapter> chapters;

  Curriculum({
    required this.id,
    required this.title,
    required this.chapters,
  });

  factory Curriculum.fromJson(Map<String, dynamic> json) {
    return Curriculum(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      chapters: (json['chapters'] as List? ?? [])
          .map((e) => Chapter.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'chapters': chapters.map((e) => e.toJson()).toList(),
  };
}

class Chapter {
  final String type;
  final ChapterItem? item;

  Chapter({
    required this.type,
    this.item,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      type: json['type'] ?? '',
      item: json['item'] != null
          ? ChapterItem.fromJson(json['item'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'item': item?.toJson(),
  };
}

class ChapterItem {
  final int id;
  final String title;
  final String? fileType;
  final String? duration;
  final bool? isFree;
  final String? videoSource;
  final String? videoUrl;

  ChapterItem({
    required this.id,
    required this.title,
    this.fileType,
    this.duration,
    this.isFree,
    this.videoSource,
    this.videoUrl,
  });

  factory ChapterItem.fromJson(Map<String, dynamic> json) {
    return ChapterItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      fileType: json['file_type'],
      duration: json['duration'],
      isFree: json['is_free'],
      videoSource: json['video_source'] ?? json['video_source_type'] ?? json['source'],
      videoUrl: json['video_url'] ?? json['video'] ?? json['file'] ?? json['link'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    if (fileType != null) 'file_type': fileType,
    if (duration != null) 'duration': duration,
    if (isFree != null) 'is_free': isFree,
    if (videoSource != null) 'video_source': videoSource,
    if (videoUrl != null) 'video_url': videoUrl,
  };
}

class CurrentProgress {
  final String type;
  final int chapterId;
  final int lessonId;
  final int watched;
  final int current;

  CurrentProgress({
    required this.type,
    required this.chapterId,
    required this.lessonId,
    required this.watched,
    required this.current,
  });

  factory CurrentProgress.fromJson(Map<String, dynamic> json) {
    return CurrentProgress(
      type: json['type'] ?? '',
      chapterId: json['chapter_id'] ?? 0,
      lessonId: json['lesson_id'] ?? 0,
      watched: json['watched'] ?? 0,
      current: json['current'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'chapter_id': chapterId,
    'lesson_id': lessonId,
    'watched': watched,
    'current': current,
  };
}
