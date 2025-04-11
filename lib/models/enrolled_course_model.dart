// import 'package:intellectra/models/reports.dart';
import 'package:intellectra/models/course.dart';
import 'package:intellectra/models/user.dart';

class EnrolledCourseModel {
  final int? id;
  final double? rating;
  final double? progress;
  final String? review;
  final User? user;
  final Course? course;
  // final List<ReportsModel>? reports;

  EnrolledCourseModel({
    this.id,
    this.rating,
    this.progress,
    this.review,
    this.user,
    this.course,
    // this.reports,
  });

  // fromJson
  factory EnrolledCourseModel.fromJson(Map<String, dynamic> json) {
    return EnrolledCourseModel(
      id: json['id'] as int?,
      rating: (json['rating'] as num?)?.toDouble(),
      progress: (json['progress'] as num?)?.toDouble(),
      review: json['review'] as String?,
      user:
          json['user'] != null
              ? User.fromJson(json['user'] as Map<String, dynamic>)
              : null,
      course:
          json['course'] != null
              ? Course.fromJson(json['course'] as Map<String, dynamic>)
              : null,
      // reports:
      //     (json['reports'] as List<dynamic>?)
      //         ?.map((e) => ReportsModel.fromJson(e as Map<String, dynamic>))
      //         .toList(),
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'progress': progress,
      'review': review,
      'user': user?.toJson(),
      'course': course?.toJson(),
      // 'reports': reports?.map((e) => e.toJson()).toList(),
    };
  }
}
