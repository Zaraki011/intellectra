import 'package:intellectra/models/course.dart';
import 'package:intellectra/models/user.dart';

class Review {
  int? id;
  double? rating;
  String? review;
  User? user;
  Course? course;

  Review({required this.id, this.user, this.course, this.rating, this.review});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int?,
      rating: (json['rating'] as num?)?.toDouble(),
      review: json['review'] as String?,
      user:
          json['user'] != null
              ? User.fromJson(json['user'] as Map<String, dynamic>)
              : null,
      course:
          json['course'] != null
              ? Course.fromJson(json['course'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'review': review,
      'user': user?.toJson(),
      'course': course?.toJson(),
    };
  }
}
