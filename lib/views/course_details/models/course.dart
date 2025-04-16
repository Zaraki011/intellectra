
import 'category.dart';
import 'quiz.dart';
import 'course_pdf_internal.dart';

class Course {
  final int? id;
  final String title;
  final String description;
  final String? pdfPath;
  final String? videoPath;
  final String? imagePath;
  final String duration;
  final double? rating;
  final int categoryId;
  final int professorId;
  final List<Quiz> quizzes;

  // API Response fields
  final String? pdfs;
  final String? videos;
  final String? image;
  final DateTime? createdAt;
  final Category? category;
  final CoursePdfInternal? pdfInternalData;

  Course({
    this.id,
    required this.title,
    required this.description,
    this.pdfPath,
    this.videoPath,
    this.imagePath,
    required this.duration,
    this.rating,
    required this.categoryId,
    required this.professorId,
    required this.quizzes,
    this.pdfs,
    this.videos,
    this.image,
    this.createdAt,
    this.category,
    this.pdfInternalData,
  });

  // Methods like fromJson/toJson will be added later

  // Factory constructor for parsing JSON from API responses
  factory Course.fromJson(Map<String, dynamic> json) {
    // Safely parse category if present
    Category? category;
    if (json['category'] != null && json['category'] is Map<String, dynamic>) {
      try {
        category = Category.fromJson(json['category'] as Map<String, dynamic>);
      } catch (e) {
        print("Error parsing category object: $e");
        category = null;
      }
    } else if (json['category'] is int) {
      category = null;
    }

    // Safely parse quizzes
    List<Quiz> quizzes = [];
    if (json['quizzes'] != null && json['quizzes'] is List) {
      quizzes =
          (json['quizzes'] as List)
              .map((q) {
                if (q is Map<String, dynamic>) {
                  try {
                    return Quiz.fromJson(q);
                  } catch (e) {
                    print("Error parsing quiz: $e, Data: $q");
                    return Quiz(
                      question: 'Invalid Quiz Data',
                      answers: ['Option A', 'Option B'],
                      correctAnswerIndex: 0,
                    );
                  }
                } else {
                  print("Skipping invalid quiz item: $q");
                  return null;
                }
              })
              .whereType<Quiz>()
              .toList();
    }

    // Safely parse pdf_internal_data
    CoursePdfInternal? pdfData;
    if (json['pdf_internal_data'] != null &&
        json['pdf_internal_data'] is Map<String, dynamic>) {
      try {
        pdfData = CoursePdfInternal.fromJson(
          json['pdf_internal_data'] as Map<String, dynamic>,
        );
      } catch (e) {
        print("Error parsing PDF internal data: $e");
        pdfData = null;
      }
    }

    int categoryIdFromData = 0;
    if (json['category'] is int) {
      categoryIdFromData = json['category'];
    } else if (category?.id != null) {
      categoryIdFromData = category!.id!;
    }

    return Course(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pdfs: json['pdfs'] as String?,
      videos: json['videos'] as String?,
      image: json['image'] as String?,
      duration: json['duration'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      categoryId: categoryIdFromData,
      professorId: _parseProfessorId(json['professor']),
      quizzes: quizzes,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'] as String? ?? '')
              : null,
      category: category,
      pdfInternalData: pdfData,
      // Local paths are not part of JSON response
      pdfPath: null,
      videoPath: null,
      imagePath: null,
    );
  }

  // toJson for sending data (e.g., for updates, if using JSON body)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'duration': duration,
      'category': categoryId,
      'professor': professorId,
      'quizzes': quizzes.map((q) => q.toJson()).toList(),
      // pdfInternalData is read-only from server, not typically sent back
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  // Helper function added outside the factory constructor, but inside the class
  static int _parseProfessorId(dynamic professorData) {
    if (professorData is int) {
      return professorData;
    } else if (professorData is Map && professorData['id'] is int) {
      return professorData['id'];
    } else if (professorData is String) {
      return int.tryParse(professorData) ?? 0;
    }
    return 0; // Default case
  }
}
