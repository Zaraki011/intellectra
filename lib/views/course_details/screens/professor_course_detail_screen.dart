import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For colors if needed
import 'package:intellectra/views/course_details/models/course.dart';
import 'package:intellectra/views/course_details/models/quiz.dart'; // Import Quiz model
import 'package:intellectra/views/course_details/services/api_service.dart';
import 'components/video_player_widget.dart'; // Reuse video player

class ProfessorCourseDetailScreen extends StatefulWidget {
  final int courseId;

  const ProfessorCourseDetailScreen({super.key, required this.courseId});

  @override
  _ProfessorCourseDetailScreenState createState() =>
      _ProfessorCourseDetailScreenState();
}

class _ProfessorCourseDetailScreenState
    extends State<ProfessorCourseDetailScreen> {
  late Future<Course> _courseFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _courseFuture = _apiService.fetchCourseDetails(widget.courseId);
  }

  Widget _buildSectionItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.red, // Change primaryColor to red
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizAsTextItem(Quiz quiz, int index) {
    String quizContent = "Q${index + 1}: ${quiz.question}\n\nAnswers:\n";
    for (int i = 0; i < quiz.answers.length; i++) {
      quizContent += "- ${quiz.answers[i]}";
      if (i == quiz.correctAnswerIndex) {
        quizContent += " (Correct)";
      }
      quizContent += "\n";
    }

    // Reuse the section item builder but give it a quiz-specific title format
    return _buildSectionItem("Quiz ${index + 1}", quizContent.trim());
  }

  Widget _buildQuizItem(Quiz quiz, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero, // Use padding outside the card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quiz ${index + 1}: ${quiz.question}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              ...List.generate(quiz.answers.length, (ansIndex) {
                bool isCorrect = ansIndex == quiz.correctAnswerIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        isCorrect
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isCorrect ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          quiz.answers[ansIndex],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight:
                                isCorrect ? FontWeight.bold : FontWeight.normal,
                            color: isCorrect ? Colors.green : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Details',
          style: TextStyle(color: Colors.red), // Make title red
        ),
      ),
      body: FutureBuilder<Course>(
        future: _courseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Course data not found.'));
          }

          final course = snapshot.data!;
          final sections = course.pdfInternalData?.sections ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  course.title,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12.0),
                // Image (if available)
                if (course.image != null && course.image!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      course.image!, // URL should be adjusted in ApiService
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey[600],
                                size: 50,
                              ),
                            ),
                          ),
                    ),
                  ),
                const SizedBox(height: 16.0),
                // Description
                Text(
                  course.description,
                  style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 16.0),
                Divider(),
                // Video (if available)
                if (course.videos != null && course.videos!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Course Video",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  VideoPlayerWidget(videoUrl: course.videos!),
                  Divider(),
                ],

                // PDF Sections (if available)
                if (sections.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Text(
                      "Course Content",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ...sections.map(
                    (section) =>
                        _buildSectionItem(section.title, section.content),
                  ),
                  Divider(),
                ],

                // Quizzes (if available)
                if (course.quizzes.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Text(
                      "Quizzes",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ...course.quizzes.asMap().entries.map(
                    (entry) => _buildQuizAsTextItem(entry.value, entry.key),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
