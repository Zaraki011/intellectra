import 'quiz.dart';

class Course {
  final int? id;
  final String title;
  final String description;
  final String? pdfs;
  final String? videos;
  final String? image;
  final String fileType;
  final String duration;
  final double rating;
  final DateTime createdAt;
  final int professorId;
  final int categoryId;
  final PdfInternalData pdfInternalData;
  final List<Quiz> quizzes;

  Course({
    this.id,
    required this.title,
    required this.description,
    this.pdfs,
    this.videos,
    required this.image,
    required this.fileType,
    required this.duration,
    required this.rating,
    required this.createdAt,
    required this.professorId,
    required this.categoryId,
    required this.pdfInternalData,
    required this.quizzes,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      pdfs: json['pdfs'],
      videos: json['videos'],
      image: json['image'] ?? '',
      fileType: json['file_type'] ?? 'unknown',
      duration: json['duration'] ?? '0',
      rating: (json['rating'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      professorId: json['professor'] ?? 0,
      categoryId: json['category'] ?? 0,
      pdfInternalData: PdfInternalData.fromJson(
        json['pdf_internal_data'] ??
            {'id': 0, 'name': '', 'table_of_contents': [], 'sections': []},
      ),
      quizzes:
          (json['quizzes'] ?? []).map<Quiz>((q) => Quiz.fromJson(q)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'duration': duration,
      'category': categoryId,
      'professor': professorId,
      'quizzes': quizzes.map((q) => q.toJson()).toList(),
      'file_type': fileType,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}

class PdfInternalData {
  final int id;
  final String name;
  final List<dynamic> tableOfContents;
  final List<CourseSection> sections;

  PdfInternalData({
    required this.id,
    required this.name,
    required this.tableOfContents,
    required this.sections,
  });

  factory PdfInternalData.fromJson(Map<String, dynamic> json) {
    return PdfInternalData(
      id: json['id'],
      name: json['name'],
      tableOfContents: json['table_of_contents'],
      sections:
          (json['sections'] as List)
              .map((section) => CourseSection.fromJson(section))
              .toList(),
    );
  }
}

class CourseSection {
  final int id;
  final String title;
  final String content;
  final int order;

  CourseSection({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
  });

  factory CourseSection.fromJson(Map<String, dynamic> json) {
    return CourseSection(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      order: json['order'],
    );
  }
}

class CourseQuiz {
  final int id;
  final String question; // The quiz question text
  final List<String> answers; // The list of possible answer texts
  final int
  correctAnswer; // The INDEX of the correct answer in the 'answers' list
  final int order;

  CourseQuiz({
    required this.id,
    required this.question,
    required this.answers,
    required this.correctAnswer, // Needs to be the correct index (0, 1, 2...)
    required this.order,
  });

  factory CourseQuiz.fromJson(Map<String, dynamic> json) {
    return CourseQuiz(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answers: List<String>.from(json['answers'] ?? []),
      // This line reads the correct answer index from the JSON field 'correct_answer'
      // If 'correct_answer' is missing or null in the JSON, it defaults to 0.
      correctAnswer: json['correct_index'] ?? 0,
      order: json['order'] ?? 0,
    );
  }
}
