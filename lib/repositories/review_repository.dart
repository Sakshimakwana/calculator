import '../core/constants/api_constants.dart';
import '../core/network/api_service.dart';
import '../models/review/review_response_model.dart';

class ReviewRepository {
  final ApiService apiService;

  ReviewRepository(this.apiService);

  // ============================================================
  // GET MY REVIEWS
  // ============================================================

  Future<ReviewResponseModel> fetchReviews({
    int page = 1,
  }) async {
    print('');
    print('============================================================');
    print('🟦 GET MY REVIEWS API');
    print('============================================================');

    print('➡️ Endpoint: ${ApiConstants.myReviews}');
    print('➡️ Method: GET');
    print('➡️ Page: $page');

    try {
      final response = await apiService.get(
        ApiConstants.myReviews,
        queryParameters: {
          'page': page,
        },
      );

      print('');
      print('✅ MY REVIEWS RESPONSE');
      print('➡️ Status Code: ${response.statusCode}');
      print('➡️ Response:');
      print(response.data);

      final result = ReviewResponseModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      print('');
      print('📋 REVIEWS PARSED');
      print('➡️ Total Reviews: ${result.reviews.length}');

      for (final review in result.reviews) {
        print(
          '⭐ Review ID: ${review.id} | '
              'Rating: ${review.rating} | '
              'Comment: ${review.comment}',
        );
      }

      print('============================================================');
      print('');

      return result;
    } catch (e) {
      print('');
      print('❌ GET MY REVIEWS ERROR');
      print('➡️ Error: $e');
      print('============================================================');
      print('');

      rethrow;
    }
  }

  // ============================================================
  // CREATE REVIEW
  // ============================================================

  Future<void> createReview({
    required int orderId,
    required int rating,
    required String comment,
  }) async {
    print('');
    print('============================================================');
    print('🟩 CREATE REVIEW API');
    print('============================================================');

    final endpoint = ApiConstants.createReview(orderId);

    final requestBody = {
      'rating': rating,
      'comment': comment,
    };

    print('➡️ Endpoint: $endpoint');
    print('➡️ Method: POST');
    print('➡️ Order ID: $orderId');
    print('➡️ Request Body:');
    print(requestBody);

    try {
      final response = await apiService.post(
        endpoint,
        data: requestBody,
      );

      print('');
      print('✅ CREATE REVIEW RESPONSE');
      print('➡️ Status Code: ${response.statusCode}');
      print('➡️ Response:');
      print(response.data);

      print('============================================================');
      print('');

    } catch (e) {
      print('');
      print('❌ CREATE REVIEW ERROR');
      print('➡️ Error: $e');

      // Dio error response
      try {
        print('➡️ Error Response: ${e.toString()}');
      } catch (_) {}

      print('============================================================');
      print('');

      rethrow;
    }
  }

  // ============================================================
  // DELETE REVIEW
  // ============================================================

  Future<void> deleteReview(int reviewId) async {
    print('');
    print('============================================================');
    print('🟥 DELETE REVIEW API');
    print('============================================================');

    final endpoint = ApiConstants.deleteReview(reviewId);

    print('➡️ Endpoint: $endpoint');
    print('➡️ Method: DELETE');
    print('➡️ Review ID: $reviewId');

    try {
      final response = await apiService.delete(
        endpoint,
      );

      print('');
      print('✅ DELETE REVIEW RESPONSE');
      print('➡️ Status Code: ${response.statusCode}');
      print('➡️ Response:');
      print(response.data);

      print('============================================================');
      print('');

    } catch (e) {
      print('');
      print('❌ DELETE REVIEW ERROR');
      print('➡️ Error: $e');
      print('============================================================');
      print('');

      rethrow;
    }
  }
}