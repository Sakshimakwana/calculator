import 'package:flutter/foundation.dart';

import '../models/review/review_model.dart';
import '../repositories/review_repository.dart';

class ReviewController extends ChangeNotifier {
  final ReviewRepository repository;

  ReviewController(this.repository);

  List<ReviewModel> reviews = [];

  bool isLoading = false;
  bool isLoadingMore = false;
  bool isDeleting = false;
  bool isCreating = false;

  String? errorMessage;

  int currentPage = 1;
  bool hasMorePages = false;

  // ============================================================
  // FETCH MY REVIEWS
  // ============================================================

  Future<void> fetchReviews({
    bool refresh = false,
  }) async {
    if (isLoading) return;

    if (refresh) {
      currentPage = 1;
      hasMorePages = false;
      errorMessage = null;
    }

    print('');
    print('🔵 ReviewController.fetchReviews()');
    print('➡️ Refresh: $refresh');
    print('➡️ Page: $currentPage');

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await repository.fetchReviews(
        page: currentPage,
      );

      if (currentPage == 1) {
        reviews = response.reviews;
      } else {
        reviews.addAll(response.reviews);
      }

      hasMorePages =
          response.pagination?.hasMorePages ?? false;

      currentPage =
          response.pagination?.currentPage ?? currentPage;

      print('');
      print('✅ Reviews loaded successfully');
      print('➡️ Reviews count: ${reviews.length}');
      print('➡️ Current page: $currentPage');
      print('➡️ Has more pages: $hasMorePages');

    } catch (e) {
      errorMessage = e.toString();

      print('');
      print('❌ ReviewController.fetchReviews ERROR');
      print('➡️ $e');

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // LOAD MORE REVIEWS
  // ============================================================

  Future<void> loadMoreReviews() async {
    if (isLoadingMore || !hasMorePages) {
      return;
    }

    final nextPage = currentPage + 1;

    print('');
    print('🔵 Loading more reviews');
    print('➡️ Next page: $nextPage');

    isLoadingMore = true;
    notifyListeners();

    try {
      final response = await repository.fetchReviews(
        page: nextPage,
      );

      reviews.addAll(response.reviews);

      hasMorePages =
          response.pagination?.hasMorePages ?? false;

      currentPage =
          response.pagination?.currentPage ?? nextPage;

      print('');
      print('✅ More reviews loaded');
      print('➡️ Total reviews: ${reviews.length}');
      print('➡️ Current page: $currentPage');
      print('➡️ Has more: $hasMorePages');

    } catch (e) {
      errorMessage = e.toString();

      print('');
      print('❌ Load more reviews ERROR');
      print('➡️ $e');

    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CREATE REVIEW
  // ============================================================

  Future<bool> createReview({
    required int orderId,
    required int rating,
    required String comment,
  }) async {
    if (isCreating) return false;

    print('');
    print('🟢 ReviewController.createReview()');
    print('➡️ Order ID: $orderId');
    print('➡️ Rating: $rating');
    print('➡️ Comment: $comment');

    isCreating = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.createReview(
        orderId: orderId,
        rating: rating,
        comment: comment,
      );

      print('');
      print('🎉 REVIEW CREATED SUCCESSFULLY');
      print('➡️ Order ID: $orderId');
      print('➡️ Rating: $rating');
      print('➡️ Comment: $comment');

      return true;

    } catch (e) {
      errorMessage = e.toString();

      print('');
      print('❌ CREATE REVIEW FAILED');
      print('➡️ $e');

      return false;

    } finally {
      isCreating = false;
      notifyListeners();
    }
  }

  // ============================================================
  // DELETE REVIEW
  // ============================================================

  Future<bool> deleteReview(int reviewId) async {
    if (isDeleting) return false;

    print('');
    print('🟠 ReviewController.deleteReview()');
    print('➡️ Review ID: $reviewId');

    isDeleting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.deleteReview(reviewId);

      reviews.removeWhere(
            (review) => review.id == reviewId,
      );

      print('');
      print('🎉 REVIEW DELETED SUCCESSFULLY');
      print('➡️ Deleted Review ID: $reviewId');
      print('➡️ Remaining Reviews: ${reviews.length}');

      return true;

    } catch (e) {
      errorMessage = e.toString();

      print('');
      print('❌ DELETE REVIEW FAILED');
      print('➡️ $e');

      return false;

    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }
}