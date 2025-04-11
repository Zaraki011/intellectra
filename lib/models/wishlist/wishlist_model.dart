import 'package:intellectra/models/course.dart';

class WishlistModel {
  int userId;
  List<Course> wishlishedCourse;

  WishlistModel({
    required this.userId,
    required this.wishlishedCourse,
  });
}
