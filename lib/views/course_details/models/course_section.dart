class CourseSection {
  final int id;
  final String title;
  final String content;
  final int order;
  // final int pdfDataId; // Foreign key ID

  CourseSection({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
    // required this.pdfDataId,
  });

  factory CourseSection.fromJson(Map<String, dynamic> json) {
    return CourseSection(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      // pdfDataId: json['pdf_data_id'] as int? ?? 0, // Adjust key based on API response
    );
  }

  Map<String, dynamic> toJson() {
    // Primarily used for reading data, toJson might not be needed
    return {
      'id': id,
      'title': title,
      'content': content,
      'order': order,
      // 'pdf_data_id': pdfDataId,
    };
  }
}
