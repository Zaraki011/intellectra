import 'course_section.dart';

class CoursePdfInternal {
  final int id;
  final String name; // PDF filename
  final List<Map<String, dynamic>> tableOfContents; // Raw JSON list for TOC
  final List<CourseSection> sections;
  // final int courseId; // Foreign key ID

  CoursePdfInternal({
    required this.id,
    required this.name,
    required this.tableOfContents,
    required this.sections,
    // required this.courseId,
  });

  factory CoursePdfInternal.fromJson(Map<String, dynamic> json) {
    List<CourseSection> parsedSections = [];
    if (json['sections'] != null && json['sections'] is List) {
      parsedSections =
          (json['sections'] as List)
              .map((s) => CourseSection.fromJson(s as Map<String, dynamic>))
              .toList();
    }

    List<Map<String, dynamic>> parsedToc = [];
    if (json['table_of_contents'] != null &&
        json['table_of_contents'] is List) {
      parsedToc = List<Map<String, dynamic>>.from(json['table_of_contents']);
    }

    return CoursePdfInternal(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      tableOfContents: parsedToc,
      sections: parsedSections,
      // courseId: json['course_id'] as int? ?? 0, // Adjust key based on API response
    );
  }

  Map<String, dynamic> toJson() {
    // Primarily used for reading data
    return {
      'id': id,
      'name': name,
      'table_of_contents': tableOfContents,
      'sections': sections.map((s) => s.toJson()).toList(),
      // 'course_id': courseId,
    };
  }
}
