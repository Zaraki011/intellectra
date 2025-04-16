import 'package:http/http.dart' as http;
// Remove the conflicting import
// import 'package:intellectra/views/course/models/course_models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p; // For basename
import 'package:http_parser/http_parser.dart'; // For MediaType

// Import your models
import '../models/course.dart';
import '../models/category.dart';
import '../models/quiz.dart';

class ApiService {
  static const String _baseUrl = "http://127.0.0.1:8000"; // Remove trailing slash
  static const String _categoryUrl = "$_baseUrl/courses/categories/";
  static const String _courseUrl = "$_baseUrl/courses/";

  Future<Course> fetchCourseDetails(int courseId) async {
    final String url = '$_courseUrl$courseId/';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // print('Response JSON for course details: ${response.body}');
        final Map<String, dynamic> jsonData = json.decode(
          utf8.decode(response.bodyBytes),
        ); // Use utf8 decoding

        // Adjust base URL for file paths if needed
        jsonData['videos'] = _adjustUrl(jsonData['videos']);
        jsonData['pdfs'] = _adjustUrl(jsonData['pdfs']);
        jsonData['image'] = _adjustUrl(jsonData['image']);

        return Course.fromJson(jsonData);
      } else {
        // print(
        //   'Error fetching course details: ${response.statusCode} - ${response.body}',
        // );
        throw Exception(
          'Failed to load course (Status code: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw Exception('Network Error: Failed to connect to the server.');
    } on HttpException {
      throw Exception('HTTP Error: Could not find the resource.');
    } on FormatException {
      throw Exception('Format Error: Bad response format from server.');
    } catch (e) {
      // print('An unknown error occurred fetching course details: $e');
      throw Exception('An unknown error occurred: $e');
    }
  }

  // Helper to adjust URLs from relative to absolute if needed
  String? _adjustUrl(String? url) {
    if (url == null || url.isEmpty || url.startsWith('http')) {
      return url;
    }
    // Assuming relative URLs are based off the base URL
    return '$_baseUrl$url';
  }

  // Fetch all categories
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(_categoryUrl));
      if (response.statusCode == 200) {
        // print('Response JSON for categories: ${response.body}');
        final List<dynamic> jsonData = json.decode(
          utf8.decode(response.bodyBytes),
        ); // Use utf8 decoding
        return jsonData.map((data) {
          // Adjust image URL
          data['categoryImage'] = _adjustUrl(data['categoryImage']);
          return Category.fromJson(data as Map<String, dynamic>);
        }).toList();
      } else {
        // print(
        //   'Error fetching categories: ${response.statusCode} - ${response.body}',
        // );
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      // print('Error in fetchCategories: $e');
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Create a new category
  Future<Category> createCategory(
    String name,
    String description, {
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_categoryUrl));
      request.fields['categoryName'] = name;
      request.fields['description'] = description;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'categoryImage', // Field name expected by Django
            imageFile.path,
            contentType: MediaType(
              'image',
              p.extension(imageFile.path).substring(1),
            ), // e.g., 'image/jpeg'
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        // Django typically returns 201 Created
        // print('Response JSON for created category: $responseBody');
        final Map<String, dynamic> jsonData = json.decode(responseBody);
        jsonData['categoryImage'] = _adjustUrl(jsonData['categoryImage']);
        return Category.fromJson(jsonData);
      } else {
        // print(
        //   'Error creating category: ${response.statusCode} - $responseBody',
        // );
        print(
          'Error creating category: ${response.statusCode} - $responseBody',
        );
        throw Exception('Failed to create category: $responseBody');
      }
    } catch (e) {
      print('Error in createCategory: $e');
      throw Exception('Failed to create category: $e');
    }
  }

  // Create a new course
  Future<Course> createCourse(
    String title,
    String description,
    String duration,
    double rating,
    int categoryId,
    int professorId,
    List<Quiz> quizzes, {
    File? pdfFile,
    File? videoFile,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_courseUrl));

      // Add text fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['duration'] = duration;
      request.fields['rating'] = rating.toString();
      request.fields['category'] = categoryId.toString(); // Send category ID
      request.fields['professor'] = professorId.toString(); // Send professor ID
      // Encode quizzes list as a JSON string
      request.fields['quizzes'] = json.encode(
        quizzes.map((q) => q.toJson()).toList(),
      );

      // Determine and set file_type based on provided files
      if (pdfFile != null) {
        request.fields['file_type'] = 'pdf';
      } else if (videoFile != null) {
        request.fields['file_type'] = 'video';
      } else {
        // Default or handle case with no file?
        // Your Django model defaults to 'video', so maybe okay?
        // Consider adding validation in the UI or here
        // request.fields['file_type'] = 'video'; // Explicitly set default if needed
      }

      // Add files if they exist
      if (pdfFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'pdfs', // Field name from Django model
            pdfFile.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      }
      if (videoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'videos', // Field name from Django model
            videoFile.path,
            contentType: MediaType(
              'video',
              p.extension(videoFile.path).substring(1),
            ), // e.g., video/mp4
          ),
        );
      }
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // Field name from Django model
            imageFile.path,
            contentType: MediaType(
              'image',
              p.extension(imageFile.path).substring(1),
            ),
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(responseBody);
        // Adjust URLs in the response
        jsonData['videos'] = _adjustUrl(jsonData['videos']);
        jsonData['pdfs'] = _adjustUrl(jsonData['pdfs']);
        jsonData['image'] = _adjustUrl(jsonData['image']);
        return Course.fromJson(jsonData);
      } else {
        print('Error creating course: ${response.statusCode} - $responseBody');
        // Try to parse error details if JSON
        String errorMessage = 'Failed to create course';
        try {
          final errorJson = json.decode(responseBody);
          errorMessage =
              errorJson.toString(); // Or extract specific error messages
        } catch (_) {}
        throw Exception(
          'Error creating course: $errorMessage (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error in createCourse: $e');
      throw Exception('Failed to create course: $e');
    }
  }

  // Fetch courses for a specific professor
  Future<List<Course>> fetchProfessorCourses(int professorId) async {
    final String url =
        '$_courseUrl?professor=$professorId'; // Filter by professor ID
    print("Fetching courses from: $url"); // Debug log

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(
          utf8.decode(response.bodyBytes),
        );
        return jsonData.map((data) {
          // Adjust URLs for files
          data['videos'] = _adjustUrl(data['videos']);
          data['pdfs'] = _adjustUrl(data['pdfs']);
          data['image'] = _adjustUrl(data['image']);
          return Course.fromJson(data as Map<String, dynamic>);
        }).toList();
      } else {
        print(
          'Error fetching professor courses: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Failed to load courses for professor');
      }
    } catch (e) {
      print('Error in fetchProfessorCourses: $e');
      throw Exception('Failed to fetch professor courses: $e');
    }
  }

  // Delete a course
  Future<void> deleteCourse(int courseId) async {
    final String url = '$_courseUrl$courseId/'; // URL for specific course
    print("Deleting course from: $url");

    try {
      final response = await http.delete(
        Uri.parse(url),
        // Add headers if needed for authentication (e.g., JWT token)
        // headers: { 'Authorization': 'Bearer YOUR_TOKEN' },
      );

      // Django REST Framework typically returns 204 No Content on successful delete
      if (response.statusCode == 204) {
        print("Course $courseId deleted successfully.");
        return; // Success
      } else if (response.statusCode == 404) {
        print('Error deleting course: Course not found.');
        throw Exception('Course not found');
      } else {
        print(
          'Error deleting course: ${response.statusCode} - ${response.body}',
        );
        throw Exception(
          'Failed to delete course (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error in deleteCourse: $e');
      throw Exception('Failed to delete course: $e');
    }
  }

  // Add a review for a course
  Future<void> createReview(
    int courseId,
    int userId,
    double rating,
    String reviewText,
    String token,
  ) async {
    final String url =
        '$_baseUrl/courses/api/reviews/'; // Assuming this endpoint
    print("Posting review to: $url"); // Debug log

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Assuming Bearer token auth
        },
        body: jsonEncode(<String, dynamic>{
          'course': courseId,
          'user': userId, // Or however user is identified
          'rating': rating,
          'review': reviewText,
        }),
      );

      if (response.statusCode == 201) {
        print('Review created successfully');
        // Optionally return the created review object if needed
      } else {
        print(
          'Error creating review: ${response.statusCode} - ${response.body}',
        );
        throw Exception(
          'Failed to create review (Status code: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error in createReview: $e');
      throw Exception('Failed to create review: $e');
    }
  }

  // Fetch all courses
  Future<List<Course>> fetchAllCourses() async {
    // Placeholder: Fetch from the main course endpoint
    // Replace with your actual logic if needed
    print("Fetching all courses from: $_courseUrl"); // Debug log

    try {
      final response = await http.get(Uri.parse(_courseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(
          utf8.decode(response.bodyBytes),
        );
        return jsonData.map((data) {
          // Adjust URLs if needed
          data['videos'] = _adjustUrl(data['videos']);
          data['pdfs'] = _adjustUrl(data['pdfs']);
          data['image'] = _adjustUrl(data['image']);
          return Course.fromJson(data as Map<String, dynamic>);
        }).toList();
      } else {
        print(
          'Error fetching all courses: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Failed to load all courses');
      }
    } catch (e) {
      print('Error in fetchAllCourses: $e');
      throw Exception('Failed to fetch all courses: $e');
    }
  }
}
