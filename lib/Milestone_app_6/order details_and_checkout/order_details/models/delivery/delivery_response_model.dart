import 'delivery_model.dart';

class DeliveryResponseModel {
  final bool success;
  final String message;
  final List<DeliveryModel> data;
  final DeliveryPaginationModel? pagination;

  const DeliveryResponseModel({
    this.success = false,
    this.message = '',
    this.data = const [],
    this.pagination,
  });

  factory DeliveryResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    final List<DeliveryModel> deliveries = [];

    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map) {
          deliveries.add(
            DeliveryModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    return DeliveryResponseModel(
      success: json['success'] == true,
      message:
      json['message']?.toString() ?? '',
      data: deliveries,
      pagination:
      json['pagination'] is Map
          ? DeliveryPaginationModel.fromJson(
        Map<String, dynamic>.from(
          json['pagination'],
        ),
      )
          : null,
    );
  }
}

// ============================================================
// PAGINATION
// ============================================================

class DeliveryPaginationModel {
  final int? perPage;
  final int? count;
  final bool hasMorePages;
  final int? currentPage;
  final int? recordsLoaded;
  final String? previousPageUrl;
  final String? nextPageUrl;
  final int? lastPage;
  final int? total;

  const DeliveryPaginationModel({
    this.perPage,
    this.count,
    this.hasMorePages = false,
    this.currentPage,
    this.recordsLoaded,
    this.previousPageUrl,
    this.nextPageUrl,
    this.lastPage,
    this.total,
  });

  factory DeliveryPaginationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryPaginationModel(
      perPage: _parseInt(json['per_page']),
      count: _parseInt(json['count']),
      hasMorePages:
      json['has_more_pages'] == true,
      currentPage:
      _parseInt(json['current_page']),
      recordsLoaded:
      _parseInt(json['records_loaded']),
      previousPageUrl:
      json['previous_page_url']?.toString(),
      nextPageUrl:
      json['next_page_url']?.toString(),
      lastPage:
      _parseInt(json['last_page']),
      total:
      _parseInt(json['total']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    );
  }
}