import 'order_info_model.dart';

class MyOrdersResponseModel {
  final bool success;
  final String message;
  final List<OrderInfoModel> data;
  final MyOrdersPaginationModel pagination;

  MyOrdersResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory MyOrdersResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    return MyOrdersResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: rawData is List
          ? rawData
          .map(
            (item) => OrderInfoModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : <OrderInfoModel>[],
      pagination: MyOrdersPaginationModel.fromJson(
        Map<String, dynamic>.from(
          json['pagination'] ?? {},
        ),
      ),
    );
  }
}

class MyOrdersPaginationModel {
  final int perPage;
  final int count;
  final bool hasMorePages;
  final int currentPage;
  final int recordsLoaded;
  final String? previousPageUrl;
  final String? nextPageUrl;
  final int lastPage;
  final int total;

  MyOrdersPaginationModel({
    required this.perPage,
    required this.count,
    required this.hasMorePages,
    required this.currentPage,
    required this.recordsLoaded,
    required this.previousPageUrl,
    required this.nextPageUrl,
    required this.lastPage,
    required this.total,
  });

  factory MyOrdersPaginationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return MyOrdersPaginationModel(
      perPage: _toInt(json['per_page']),
      count: _toInt(json['count']),
      hasMorePages: json['has_more_pages'] == true,
      currentPage: _toInt(json['current_page']),
      recordsLoaded: _toInt(json['records_loaded']),
      previousPageUrl:
      json['previous_page_url']?.toString(),
      nextPageUrl:
      json['next_page_url']?.toString(),
      lastPage: _toInt(json['last_page']),
      total: _toInt(json['total']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }
}