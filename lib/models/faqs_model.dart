
class FaqResponse {
  final String status;
  final List<FaqModel> data;
  final FaqPagination pagination;

  FaqResponse({
    required this.status,
    required this.data,
    required this.pagination,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    return FaqResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) =>
          FaqModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
      pagination: FaqPagination.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class FaqModel {
  final String question;
  final String answer;

  FaqModel({
    required this.question,
    required this.answer,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class FaqPagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final FaqPaginationLinks links;

  FaqPagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.links,
  });

  factory FaqPagination.fromJson(Map<String, dynamic> json) {
    return FaqPagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      links: FaqPaginationLinks.fromJson(
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

class FaqPaginationLinks {
  final String? first;
  final String? prev;
  final String? next;
  final String? last;

  FaqPaginationLinks({
    this.first,
    this.prev,
    this.next,
    this.last,
  });

  factory FaqPaginationLinks.fromJson(Map<String, dynamic> json) {
    return FaqPaginationLinks(
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
