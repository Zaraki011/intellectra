import 'package:intellectra/models/course.dart';
import 'package:flutter/material.dart';

class WishlistViewModel extends ChangeNotifier {
  final List<Course> _wishlishedCourse = [];

  List<Course>? get wishlishedCourse => _wishlishedCourse;
}
