class Review {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final int rating;
  final String reviewText;
  final DateTime createdDateTimeUTC;
  final DateTime updatedDateTimeUTC;
  final DateTime? responseTime;
  final int reviewType;
  final String reviewerName;
  final String revieweeName;
  final String serviceRequestId;

  Review({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    required this.reviewText,
    required this.createdDateTimeUTC,
    required this.updatedDateTimeUTC,
    this.responseTime,
    required this.reviewType,
    required this.reviewerName,
    required this.revieweeName,
    required this.serviceRequestId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['Id'],
      reviewerId: json['ReviewerId'],
      revieweeId: json['RevieweeId'],
      rating: json['Rating'],
      reviewText: json['ReviewText'],
      createdDateTimeUTC: DateTime.parse(json['CreatedDateTimeUTC']),
      updatedDateTimeUTC: DateTime.parse(json['UpdatedDateTimeUTC']),
      responseTime: json['ResponseTime'] != null
          ? DateTime.parse(json['ResponseTime'])
          : null,
      reviewType: json['ReviewType'],
      reviewerName: json['ReviewerName'],
      revieweeName: json['RevieweeName'],
      serviceRequestId: json['ServiceRequestId'],
    );
  }

  static List<Review> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Review.fromJson(json)).toList();
  }
}