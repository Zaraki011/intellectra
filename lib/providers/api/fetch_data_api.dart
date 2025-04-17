import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intellectra/models/category.dart';
import 'package:intellectra/models/course.dart';

Future<List<Categorie>> fetchCategories(String baseUrl) async {
  final response = await http.get(Uri.parse("$baseUrl/courses/categories/"));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Categorie.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load categories");
  }
}

Future<List<Course>> fetchCourses(String baseUrl) async {
  final response = await http.get(Uri.parse("$baseUrl/courses/"));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Course.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load courses");
  }
}

Future<Course> fetchCourseById(String baseUrl, int id) async {
  final response = await http.get(Uri.parse('$baseUrl/courses/$id/'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Course.fromJson(json);
  } else {
    throw Exception('Erreur de récupération du cours');
  }
}
