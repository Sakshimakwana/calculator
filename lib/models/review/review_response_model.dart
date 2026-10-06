import 'review_model.dart';

class ReviewResponseModel {
  final bool success;
  final String message;
  final List<ReviewModel> reviews;
  final ReviewPaginationModel? pagination;

  ReviewResponseModel({
    required this.success,
    required this.message,
    required this.reviews,
    required this.pagination,
  });

  factory ReviewResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final data = json['data'];

    final List<ReviewModel> reviews = [];

    if (data is List) {
      for (final item in data) {
        if (item is Map) {
          reviews.add(
            ReviewModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    return ReviewResponseModel(
      success: json['success'] == true,
      message:
      json['message']?.toString() ?? '',
      reviews: reviews,
      pagination:
      json['pagination'] is Map
          ? ReviewPaginationModel.fromJson(
        Map<String, dynamic>.from(
          json['pagination'],
        ),
      )
          : null,
    );
  }
}

class ReviewPaginationModel {
  final int perPage;
  final int count;
  final bool hasMorePages;
  final int currentPage;
  final int recordsLoaded;
  final int lastPage;
  final int total;

  ReviewPaginationModel({
    required this.perPage,
    required this.count,
    required this.hasMorePages,
    required this.currentPage,
    required this.recordsLoaded,
    required this.lastPage,
    required this.total,
  });

  factory ReviewPaginationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ReviewPaginationModel(
      perPage: _toInt(json['per_page']),
      count: _toInt(json['count']),
      hasMorePages:
      json['has_more_pages'] == true,
      currentPage:
      _toInt(json['current_page']),
      recordsLoaded:
      _toInt(json['records_loaded']),
      lastPage:
      _toInt(json['last_page']),
      total:
      _toInt(json['total']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }
}