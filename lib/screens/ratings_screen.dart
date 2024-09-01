import 'package:clickclinician/models/review.dart';
import 'package:clickclinician/shared/api_calls.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:flutter/material.dart';

class ClinicianReview extends StatefulWidget {
  const ClinicianReview({super.key});

  @override
  State<StatefulWidget> createState() => ClinicianReviewState();
}

class ClinicianReviewState extends State<ClinicianReview> {
  List<Review> reviews = [];
  Map<int, int> ratingBreakdown = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
  double averageRating = 0.0;
  String clinicianName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedReviews = await ApiCalls.getReviews(
        context: context,
      );

      setState(() {
        reviews = fetchedReviews;
        _calculateRatingStats();
        if (reviews.isNotEmpty) {
          clinicianName = reviews.first.revieweeName;
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading reviews: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _calculateRatingStats() {
    if (reviews.isEmpty) return;

    ratingBreakdown = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    int totalRating = 0;

    for (var review in reviews) {
      ratingBreakdown[review.rating] =
          (ratingBreakdown[review.rating] ?? 0) + 1;
      totalRating += review.rating;
    }

    averageRating = totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            backgroundColor: Color.fromARGB(255, 240, 240, 240),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DesignWidgets.getAppBar(context, "Reviews"),
                    Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            _buildRatingBreakdown(),
                            DesignWidgets.addVerticalSpace(24.0),
                            _buildReviewList(),
                          ],
                        ))
                  ]),
            ),
          ));
  }

  Widget _buildRatingBreakdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  averageRating.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                DesignWidgets.addHorizontalSpace(4.0),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 26,
                ),
              ],
            ),
            Text(
                '${reviews.length} total ${reviews.length > 1 ? "reviews" : "review"}'),
            DesignWidgets.addVerticalSpace(8),
            ...[5, 4, 3, 2, 1].map((rating) => _buildRatingBar(rating)),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int rating) {
    final count = ratingBreakdown[rating] ?? 0;
    final percentage =
        reviews.isNotEmpty ? (count / reviews.length) * 100 : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text('$rating Stars')),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          SizedBox(
              width: 40, child: Text('($count)', textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${reviews.length} ${reviews.length > 1 ? "reviews" : "review"} for $clinicianName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: DesignWidgets.divider(),
            ),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ListTile(
                leading: const Icon(
                  Icons.account_circle_rounded,
                  color: ColorsUI.primaryColor,
                  size: 72,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          review.rating,
                          (index) => const Icon(Icons.star,
                              size: 18, color: Colors.amber),
                        ),
                        DesignWidgets.addHorizontalSpace(8),
                        Text(
                          _formatDate(review.createdDateTimeUTC),
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: review.reviewText.isNotEmpty
                    ? Text(review.reviewText)
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: review.reviewText.isEmpty ? 8 : 0,
                ),
                titleAlignment: review.reviewText.isEmpty
                    ? ListTileTitleAlignment.center
                    : ListTileTitleAlignment.threeLine,
              );
            },
          ),
          DesignWidgets.addVerticalSpace(12.0),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
