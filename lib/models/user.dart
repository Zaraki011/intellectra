import 'package:intellectra/models/course.dart';
import 'package:intellectra/models/category.dart';

class User {
  int? id;
  String? avatar; // profile_image
  String? firstname;
  String? lastname;
  String? email; // username
  String? password;
  String? role;
  Categorie? specialization; // category
  List<Course>? enrolledCourse;

  User({
    this.id,
    this.avatar,
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.role,
    this.specialization,
    this.enrolledCourse,
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      avatar: json['profile_image'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['username'] as String?,
      password: json['password'] as String?,
      role: json['role'] as String?,
      specialization:
          json['category'] != null
              ? Categorie.fromJson(json['category'] as Map<String, dynamic>)
              : null,
      enrolledCourse:
          (json['enrolled_course'] as List<dynamic>?)
              ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_image': avatar,
      'firstname': firstname,
      'lastname': lastname,
      'username': email,
      'password': password,
      'role': role,
      'category': specialization?.toJson(),
      'enrolled_course': enrolledCourse?.map((e) => e.toJson()).toList(),
    };
  }
}
